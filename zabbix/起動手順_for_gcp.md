# Zabbix起動手順

docker-compose.yml作成については、記載しないが
参考にしたURLは以下である。

https://yomon.hatenablog.com/entry/2018/03/29/Zabbix公式コンテナとdocker-compose使って検証環境を簡単に作成

## 起動

```docker
cd /mnt/c/Users/blue_/Dropbox/99.work/自宅学習/docker/docker/zabbix
sudo su -
docker-compose up -d
```

## Web管理画面にアクセス

network


Admin:zabbix

## 日本語化

右上の人型アイコンをクリック
LanguageをJapaneseにしupdateをクリック

## NIC設定有効化

AgentのNICをDNSで zabbix_agent　を見るように変更します。後は有効化して使います。

## 起動順序

Creating zdb001 ... done
Creating zsv001 ... done
Creating zwb001 ... done


---

## zabbix container all stop and remove

docker ps | grep z | awk '{print $1}' | while read id; do docker stop $id; docker rm $id; done

## zabbix image all remove

docker images | grep -e z -e maria | awk '{print $3}' | while read id; do docker image rm $id; done
