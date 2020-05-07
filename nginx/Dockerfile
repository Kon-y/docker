FROM dockerkon/default-centos:20200505
ENV container docker
RUN yum -y update
RUN yum install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y --enablerepo=nginx nginx
ADD nginx.conf /etc/nginx/
RUN echo "Hello Nginx." > /usr/share/nginx/html/index.html
RUN systemctl enable nginx
EXPOSE 8080 22 10050
CMD /sbin/init