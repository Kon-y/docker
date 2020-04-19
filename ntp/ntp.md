以下URLを参照
ホストでNTP同期していれば、コンテナも同期する仕様らしい。

https://qiita.com/hirotaka-tajiri/items/f5900b236a005d7ffe58

dockerのコンテナはハードウェアを仮想化しないので、clockデータはホストを共有している、
そのため、ホスト側の時刻変更を即コンテナにも影響する。
つまり、ホスト側でNTPDなどで時刻同期をしていれば、コンテナ内の時刻管理は必要がない

---

手動インストールする場合

docker exec -it {container id} /bin/bash #Centosの場合

yum -y install chrony

vi /etc/chrony.conf

```vi
pool 2.centos.pool.ntp.org iburst
　↓　コメントアウトする
#pool 2.centos.pool.ntp.org iburst
```

以下を追記する。
server 192.168.1.9 iburst  #### 追加 : docker host
port 0

systemctl enable chronyd.service

systemctl list-unit-files --type service | egrep "(ntp|chronyd)"
 -> chronyd.service                        enabled と表示される。
