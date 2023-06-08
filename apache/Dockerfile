FROM centos:centos7.1.1503
ENV container docker
ENV http_proxy http://proxy.your.site.com:8080
ENV https_proxy http://proxy.your.site.com:8080
RUN yum update -y && yum clean all
RUN yum swap -y fakesystemd systemd && yum clean all
RUN yum install -y httpd && yum clean all
RUN echo "Hello Apache." > /var/www/html/index.html
RUN systemctl enable httpd
EXPOSE 80
