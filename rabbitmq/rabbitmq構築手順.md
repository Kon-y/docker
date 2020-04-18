# インストール手順

## 参考サイト

```url
https://sys-guard.com/post-14412/
https://blog.masu-mi.me/post/2016/09/15/rabbitmq_clustering_mirroring_config/
https://qiita.com/ptiringo/items/c554fa66f0d985394fed
```

## EPELのインストール(docker host)

C:\Users\blue_\Dropbox\99.work\自宅学習\docker\dockerhostとしての設定.md

## docker-composeのインストール(docker host)

```bash
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## start docker-compose

```bash
cd /mnt/c/Users/blue_/Dropbox/99.work/自宅学習/docker/docker/rabbitmq
docker-compose up -d
```

## 管理画面にアクセス

```url
http://localhost:15672
http://192.168.1.9:15672

ID:guest
PS:guest
```

## ユーザーを参照

```docker
docker exec rabbitmq rabbitmqctl list_users
```

## Exchange の情報を全て表示

```docker
docker exec rabbitmq rabbitmqctl list_exchanges name type durable auto_delete internal arguments policy
```

## Virtual hostを追加

```docker
docker exec rabbitmq rabbitmqctl add_vhost nginx001
docker exec rabbitmq rabbitmqctl add_vhost nginx002

管理画面：
Admin > Virtual Hosts で登録されていることを確認できる。
```

## ユーザーの追加

```docker
docker exec rabbitmq rabbitmqctl add_user admin admin
  -> Adding user "admin" ...と表示される。
```

## ユーザーにタグを付与

```docker
docker exec rabbitmq rabbitmqctl set_user_tags admin administrator
  -> Setting tags for user "admin" to [administrator] ...と表示される。

管理画面：
Admin > Users で登録されていることを確認できる。
```

## ユーザーに Virtual Host に対するパーミッションを設定

```docker
docker exec rabbitmq rabbitmqctl set_permissions -p nginx001 admin ".*" ".*" ".*"
  -> Setting permissions for user "admin" in vhost "nginx001" ...と表示される。

docker exec rabbitmq rabbitmqctl set_permissions -p nginx002 admin ".*" ".*" ".*"
  -> Setting permissions for user "admin" in vhost "nginx002" ...と表示される。
```

## 現在の設定を JSON ファイルで出力

```docker
docker exec rabbitmq rabbitmqadmin export /tmp/export.json
  -> Exported definitions for localhost to "/tmp/export.json"と表示される。
docker exec rabbitmq cat /tmp/export.json | jq .
```

## ホストリスト

```docker
docker exec rabbitmq rabbitmqctl list_vhosts
docker exec rabbitmq rabbitmqctl cluster_status
```

## cluster登録

```bash
docker exec -it rabbitmq /bin/bash
RABBITMQ_NODENAME=rabbit rabbitmq-server -detached
RABBITMQ_NODE_PORT=5673 RABBITMQ_NODENAME=nginx001 rabbitmq-server -detached
RABBITMQ_NODE_PORT=5673 RABBITMQ_NODENAME=nginx002 rabbitmq-server -detached
```

---

error解析から

```messages
Error: unable to perform an operation on node 'nginx002@c5336a0dfdc4'. Please see diagnostics information and suggestions below.

Most common reasons for this are:

* Target node is unreachable (e.g. due to hostname resolution, TCP connection or firewall issues)
* CLI tool fails to authenticate with the server (e.g. due to CLI tool's Erlang cookie not matching that of the server)
* Target node is not running

In addition to the diagnostics info below:

* See the CLI, clustering and networking guides on https://rabbitmq.com/documentation.html to learn more
* Consult server logs on node nginx002@c5336a0dfdc4
* If target node is configured to use long node names, don't forget to use --longnames with CLI tools

DIAGNOSTICS

===========

attempted to contact: [nginx002@c5336a0dfdc4]

nginx002@c5336a0dfdc4:

* connected to epmd (port 4369) on c5336a0dfdc4
* epmd reports: node 'nginx002' not running at all
                  other nodes on c5336a0dfdc4: [rabbit]
* suggestion: start the node

Current node details:

* node name: 'rabbitmqcli-4520-rabbit@c5336a0dfdc4'
* effective user's home directory: /var/lib/rabbitmq
* Erlang cookie hash: 3kck+RSVJQT+9cURf7TkUg==
```
