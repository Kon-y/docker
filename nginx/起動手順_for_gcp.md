# docker build

Dockerfileの作成については、省略している。

// gcp instance
cd /home/tec2020_startup/docker/nginx
git pull
sudo docker build -f ./Dockerfile -t centos:nginx --no-cache=true .

sudo docker images

REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
centos                               nginx               fc8f406135b2        9 seconds ago       370 MB

sudo docker run -d --privileged --net=int_net --ip=172.19.0.8 -p 8081:8080 -p 9006:22 --name ngx001 -h ngx001 --cpuset-cpus=0 centos:nginx /sbin/init
                     └> ホストのデバイスにアクセス可能になる。

sudo docker ps -a

sudo docker exec ngx001 ls -ld /run/chrony
sudo docker exec ngx001 chown root.root /run/chrony
sudo docker exec ngx001 ls -ld /run/chrony
sudo docker exec ngx001 systemctl restart chronyd.service
sudo docker exec ngx001 systemctl status chronyd.service | grep active
sudo docker exec ngx001 chronyc sources
sudo docker exec ngx001 timedatectl status

sudo docker exec ngx001 systemctl status nginx | grep active

sudo docker exec -it ngx001 /bin/bash
curl http://$(hostname -I | awk -F" " '{print $1}'):8080/index.html
exit

ポートフォワーディングできているか、WSLホストから確認
curl http://$(hostname -I | awk -F" " '{print $1}'):8081/index.html

---

## 2台目

sudo docker run -d --privileged --net=int_net --ip=172.19.0.9 -p 8082:8080 -p 9007:22 --name ngx002 -h ngx002 --cpuset-cpus=0 centos:nginx /sbin/init

sudo docker exec ngx002 ls -ld /run/chrony
sudo docker exec ngx002 chown root.root /run/chrony
sudo docker exec ngx002 ls -ld /run/chrony
sudo docker exec ngx002 systemctl restart chronyd.service
sudo docker exec ngx002 systemctl status chronyd.service | grep active
sudo docker exec ngx002 chronyc sources
sudo docker exec ngx002 timedatectl status

sudo docker exec ngx002 systemctl status nginx | grep active

sudo docker exec -it ngx002 /bin/bash
curl http://$(hostname -I | awk -F" " '{print $1}'):8080/index.html
exit

ポートフォワーディングできているか、dockerホストから確認
curl http://$(hostname -I | awk -F" " '{print $1}'):8082/index.html

---

## nginx container all stop and remove

docker ps | grep nginx | awk '{print $1}' | while read id; do docker stop $id; docker rm $id; done

## nginx image all remove

docker images | grep nginx | awk '{print $3}' | while read id; do docker image rm $id; done
