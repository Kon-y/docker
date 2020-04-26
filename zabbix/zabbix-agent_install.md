# zabbix agent install

参考URL
https://qiita.com/skouno25/items/39d1cfa5f56df3107ed6

各Linuxサーバにインストールする。

```
## CentOS 7
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

## CentOS 6
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-release-3.0-1.el6.noarch.rpm

yum install zabbix-agent
```

## settings

~~~
Server=172.19.0.6
ServerActive=172.19.0.6
#Hostname=[Hostname] (コメントアウトもしくはZabbixで表示するホスト名を設定)
HostnameItem=system.hostname (Hostnameをコメントアウトする場合はコメントアウト外す)
~~~