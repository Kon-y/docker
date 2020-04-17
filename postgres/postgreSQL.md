# postgreSQL on docker

## 前提

* Dockerインストール済
* Dockerについての基本的な知識がある
* docker compose触ったことある。

## 知見

* リレーショナルデータベースでは横に伸びない方のテーブルだけを扱う。(横方向に伸びるテーブルやSQLを書き換えるのが苦手)
* 縦に伸びるのは、テーブルやSQLを書き換える必要がなくデータに応じて自動的に伸びるので、得意としている。
* 縦にも横にも伸びるテーブルは「2次元のテーブル」と言う。
* テーブルには行の順番がない。(行の順番は保持されない。)なぜならリレーショナルではデータは「行の集合」であって「行のリスト」ではない。

## テスト環境

Windows10Pro + WSL(Ubuntu) + docker on Windows

```bash
WSL？
root@DESKTOP-72R96RU:/mnt/c/Users/blue_/Dropbox/99.work/自宅学習# uname -a
Linux DESKTOP-72R96RU 4.4.0-18362-Microsoft #476-Microsoft Fri Nov 01 16:53:00 PST 2019 x86_64 GNU/Linux

WSLのOSバージョン
[ipsadm@Kali_Linux docker]$ cat /etc/issue
Ubuntu 16.04.6 LTS \n \l

Docker
[ipsadm@Kali_Linux docker]$ docker version
Client:
 Version:           18.09.7
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        2d0083d
 Built:             Fri Aug 16 14:19:38 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.5
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.12
  Git commit:       633a0ea
  Built:            Wed Nov 13 07:29:19 2019
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v1.2.10
  GitCommit:        b34a5c8af56e510852c35414db4c1f4fa6172339
 runc:
  Version:          1.0.0-rc8+dev
  GitCommit:        3e425f80a8c931f88e6d94a8c831b9d5aa481657
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

## 環境構築

```bash
sudo apt install docker.io
sudo apt update
sudo apt upgrade
sudo apt install docker-compose

docker -v
ps -ef | grep docker
service docker status # WSLではsystemctlコマンドは使用できない。

cat /etc/group | grep docker
sudo groupadd docker
sudo usermod -aG docker $USER
groups $USER

mkdir -p $PWD/docker/db/init/

cat <<__YML__ | tee docker-compose.yml >/dev/null
version: '2'

services:
  postgres:
    image: postgres:11.4-alpine
    restart: always
    environment:
      TZ: "Asia/Tokyo"
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: test_db
    ports:
      - 5432:5432
    volumes:
      - postgres:/var/lib/postgresql/data
      - $PWD/docker/db/init:/docker-entrypoint-initdb.d

  pgadmin:
    image: dpage/pgadmin4
    restart: always
    ports:
      - 8080:80
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin
    volumes:
      - pgadmin:/var/lib/pgadmin
    depends_on:
      - postgres

volumes:
  postgres:
  pgadmin:
__YML__

cat <<__SQL__ | tee $PWD/docker/db/init/1_init.sql >/dev/null
CREATE TABLE public.centerinfo
(
   centerid text NOT NULL,
   publicurl text NOT NULL,
   user text NOT NULL,
   pw text NOT NULL,
   PRIMARY KEY (centerid)
)
WITH (
   OIDS = FALSE
);
__SQL__

docker-compose up -d
  ## -> http://localhost:8080でPostgreSQLの管理画面にログインできる。(できるけどGUI操作については説明なし)

  以下のエラーメッセージはDocker Desktopが起動していない場合に出力する。
  ## -> ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?
  ## -> If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.

  以下のエラーメッセージはcom.docker.backend.exeがポートをつかんで離さなかったため。
  対処としてはDocker Desktopを停止、com.docker.backendのプロセスを再起動、Docker Desktopを起動させる。
  原因：たぶん正しい手順を踏んでDesktop側のDocker APLを利用としたテストを実施したからだと思う。
  ## -> ERROR: for docker_postgres_1  Cannot start service postgres: driver failed programming external connectivity on endpoint docker_postgres_1
  ## -> (4a37fd368e75a492b94a29b77b5194f8e7c25052e86acb82f2b2b844496f1426): Error starting userland proxy: /forwards/expose/port returned unexpected status: 500

  ## -> ERROR: for postgres  Cannot start service postgres: driver failed programming external connectivity on endpoint docker_postgres_1
  ## -> (4a37fd368e75a492b94a29b77b5194f8e7c25052e86acb82f2b2b844496f1426): Error
  ## -> starting userland proxy: /forwards/expose/port returned unexpected status: 500
  ## -> ERROR: Encountered errors while bringing up the project.

docker-compose config --service
  ## -> サービス名を出力
  出力例：
  postgres
  pgadmin

docker pull postgres:11
  ## -> 11: Pulling from library/postgres

docker run --name posgre11 -d -e POSTGRES_PASSWORD=pass1 postgres:11

起動されたことを確認する。
docker ps -a
  ## -> CONTAINER ID  IMAGE        COMMAND                 CREATED        STATUS         PORTS     NAMES
  ## -> 718476c24b25  postgres:11  "docker-entrypoint.s…"  5 minutes ago  Up 5 minutes   5432/tcp  posgre11

コンテナにアクセスする
docker exec -it posgre11 bash

各種コマンドが存在することを確認する
which psql createuser createdb

作成したいDBユーザー(user1)が存在しないことを確認する。(ユーザーは任意)
psql -U postgres -c '\du'

DBユーザー「user1」を作成する。
createuser -U postgres user1

作成されたことを確認する
psql -U postgres -c '\du'

##                                   List of roles
## Role name |                         Attributes                         | Member of
##-----------+------------------------------------------------------------+-----------
## postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
## user1     |                                                            | {}  <- user1が存在することを確認する

作成したいDB(testdb1)が存在していないことを確認する。(DB名は任意)
psql -U postgres -l

DB(testdb1)を作成する。
createdb -U postgres -O user1 -E UTF8 --locale=C -T template0 testdb1

DB(testdb1)が存在していることを確認する。
psql -U postgres -l

##                                 List of databases
##   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
##-----------+----------+----------+------------+------------+-----------------------
## postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
## template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
##           |          |          |            |            | postgres=CTc/postgres
## template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
##           |          |          |            |            | postgres=CTc/postgres
## testdb1   | user1    | UTF8     | C          | C          |                             <- 作成されている。
##(4 rows)

DBユーザーでDBにアクセスする。
psql -U user1 testdb1
  ## -> プロンプトが「testdb1=>」に変わる。

簡単なSQLコマンドを実行してみる。
select current_date;

## current_date
##--------------
## 2020-02-23
##(1 row)

postgreSQLからログアウトする。
\q
```

---

## 基本的な操作

### テーブルを作成する(create table)

```bash
create table testtable1 (
id integer primary key
, name text not null unique
, age integer
);
  ## -> CREATE TABLE
```

### テスト用テーブルを作成する(insert into)

```bash
insert into testtable1(id, name, age)
values (101, 'Alice', 20)
     , (102, 'Bob'  , 25)
     , (103, 'Cathy', 22)
;
  ## -> INSERT 0 3

テーブルが作成されたことを確認する
\dt

##          List of relations
## Schema |    Name    | Type  | Owner
##--------+------------+-------+-------
## public | testtable1 | table | user1
##(1 row)
```

## テスト用テーブルを削除する

```bash
drop table testtable1;
```

## テスト用テーブルに新しい行を挿入する

```bash
insert into testtable1(id, name, age) values (104, 'bruno', 21);
insert into testtable1(id, name, age) values (105, 'mars', 23);
insert into testtable1(id, name, age) values (106, 'BSB', 24);

or ↓ 上記3行を1行で挿入する場合

insert into testtable1(id, name, age)
values (104, 'bruno', 21)
, (105, 'mars' , 23)
, (106, 'BSB', 24);
```

## テスト用テーブルの行を検索する

```bash
select * from testtable1;

## id  | name  | age
##-----+-------+-----
## 101 | Alice |  20
## 102 | Bob   |  25
## 103 | Cathy |  22
## 104 | bruno |  21
## 105 | mars  |  23
## 106 | BSB   |  24
##(6 rows)
```

## 特定の情報のみ抽出する(select)

```bash
テストテーブルからBSBのnameとageを抽出する。
select name, age from testtable1 where name = 'BSB';
select * from testtable1;
## name | age
##------+-----
## BSB  |  24
##(1 row)
```

## テーブルの行を更新する(update)

```bash
ageを1つ増やす
update testtable1 set age = age + 1;
select * from testtable1;
## id  | name  | age
##-----+-------+-----
## 101 | Alice |  21
## 102 | Bob   |  26
## 103 | Cathy |  23
## 104 | bruno |  22
## 105 | mars  |  24
## 106 | BSB   |  25
##(6 rows)
```

## 特定の行だけを更新する(update)

注) update 文では条件を指定しなければすべての行が更新される。

```bash
名前が「BSB」の行だけ、年齢を「27」に更新する
update testtable1 set age = 27 where name = 'BSB';
select * from testtable11;
## id  | name  | age
##-----+-------+-----
## 101 | Alice |  21
## 102 | Bob   |  26
## 103 | Cathy |  23
## 104 | bruno |  22
## 105 | mars  |  24
## 106 | BSB   |  27 ★BSBのageが27に更新している。
##(6 rows)
```

## 特定のカラムでsortする(order)

```bash
nameで並び替えする。
select * from testtable1 order by name;

## id  | name  | age
##-----+-------+-----
## 101 | Alice |  21
## 106 | BSB   |  27
## 102 | Bob   |  26
## 103 | Cathy |  23
## 104 | bruno |  22
## 105 | mars  |  24
##(6 rows)
```

## テーブルから行を削除する(delete)

```bash
nameでBSBのみを削除する。
delete from testtable1 where name = 'BSB';
select * from testtable1;
## id  | name  | age
##-----+-------+-----
## 101 | Alice |  21
## 102 | Bob   |  26
## 103 | Cathy |  23
## 104 | bruno |  22
## 105 | mars  |  24
##(5 rows)
```

## container停止

```bash
docker ps -a
  ## -> 停止したいCONTAINER IDを記憶する。

docker stop {CONTAINER ID}
docker ps -a
```
