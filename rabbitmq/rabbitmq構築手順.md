# インストール手順

起動に失敗する：原因特定できず・・・

## 参考サイト

```url
https://sys-guard.com/post-14412/
https://blog.masu-mi.me/post/2016/09/15/rabbitmq_clustering_mirroring_config/
https://qiita.com/ptiringo/items/c554fa66f0d985394fed
```

## dockerホストの設定

C:\Users\blue_\Dropbox\99.work\自宅学習\docker\dockerhostとしての設定.md

## start docker-compose

```bash
cd /mnt/c/Users/blue_/Dropbox/99.work/自宅学習/docker/docker/rabbitmq
docker build -f ./Dockerfile -t rabbitmq:centos7 --no-cache=true .
docker run -d --privileged -e RABBITMQ_USER=foo -e RABBITMQ_PASS=bar --net=int_net --ip=172.19.0.7 -p 5672:5672 -p 15672:15672 -p 9005:22 -p 4369:4369 -p 25672:25672 --name rmq001 -h rmq001 rabbitmq:centos7 /sbin/init
```

## 管理画面にアクセス

```url
http://localhost:15672
http://192.168.1.9:15672

ID:guest
PS:guest
```

## 管理インターフェースからrabbitmqadminツールをダウンロード

```cmd
wget localhost:15672/cli/rabbitmqadmin
chmod +x rabbitmqadmin
```

## ユーザーを参照

```cmd
./rabbitmqadmin list users
```

## Exchange の情報を全て表示

```docker
docker exec rmq001 rabbitmqctl list_exchanges name type durable auto_delete internal arguments policy
```

## Virtual hostを追加

```docker
docker exec rmq001 rabbitmqctl add_vhost nginx001
docker exec rmq001 rabbitmqctl add_vhost nginx002

管理画面：
Admin > Virtual Hosts で登録されていることを確認できる。
```

## ユーザーの追加

```docker
docker exec rmq001 rabbitmqctl add_user admin admin
  -> Adding user "admin" ...と表示される。
```

## ユーザーにタグを付与

```docker
docker exec rmq001 rabbitmqctl set_user_tags admin administrator
  -> Setting tags for user "admin" to [administrator] ...と表示される。

管理画面：
Admin > Users で登録されていることを確認できる。
```

## ユーザーに Virtual Host に対するパーミッションを設定

```docker
docker exec rmq001 rabbitmqctl set_permissions -p nginx001 admin ".*" ".*" ".*"
  -> Setting permissions for user "admin" in vhost "nginx001" ...と表示される。

docker exec rmq001 rabbitmqctl set_permissions -p nginx002 admin ".*" ".*" ".*"
  -> Setting permissions for user "admin" in vhost "nginx002" ...と表示される。
```

## 現在の設定を JSON ファイルで出力

```docker
./rabbitmqadmin export /tmp/export.json
  ## -> Exported definitions for localhost to "/tmp/export.json"と表示される。
cat /tmp/export.json | jq .
```

## ホストリスト

```docker
docker exec rmq001 rabbitmqctl list_vhosts
docker exec rmq001 rabbitmqctl cluster_status
```

## cluster登録

```bash
docker exec -it rmq001 /bin/bash
RABBITMQ_NODENAME=rmq001 rabbitmq-server -detached
RABBITMQ_NODE_PORT=5673 RABBITMQ_NODENAME=nginx001 rabbitmq-server -detached
RABBITMQ_NODE_PORT=5673 RABBITMQ_NODENAME=nginx002 rabbitmq-server -detached
```
