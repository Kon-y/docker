FROM centos:latest
ENV container docker
RUN yum -y update
RUN yum swap -y fakesystemd systemd && yum clean all
RUN yum install -y epel-release && yum clean all
RUN yum install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y --enablerepo=nginx nginx
RUN yum install -y openssh-server openssh-clients passwd iproute chrony tzdata vim less nmap sudo && yum clean all
ADD nginx.conf /etc/nginx/
ADD chrony.conf /etc/
RUN echo "Hello Nginx." > /usr/share/nginx/html/index.html
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN sed -ri 's/ChallengeResponseAuthentication yes/#ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/GSSAPICleanupCredentials no/#CGSSAPICleanupCredentials no/' /etc/ssh/sshd_config
RUN systemctl enable nginx
RUN systemctl enable chronyd.service
RUN systemctl enable sshd.service
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo root:aslinux | chpasswd
EXPOSE 8080 22 10050
CMD /sbin/init