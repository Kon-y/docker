# knowhow

## SSH

対向サーバ内のWSL2にSSH Connectionしたい。

リモート元：XPS13
リモート先：Windows10pro 20H2

## vEthernet (Default Switch)

XPS13:172.18.16.1       -> 192.168.191.1/16
Desktp:192.168.192.1

## vEthernet (WSL)

default gateway?

XPS13:172.25.176.1      -> 172.26.143.1/16
Desktop:172.26.144.1/16

## WSL2-IP

XPS13：172.25.190.21    -> 172.26.158.49(static)
Desktop：172.26.158.49

WSL2のIP変更方法
https://qiita.com/neko_the_shadow/items/25b797cb436078b9e832
https://qiita.com/yabeenico/items/15532c703974dc40a7f5

## server

httpdを起動させる。
ポートが開いていることを確認する。(80)

## client
