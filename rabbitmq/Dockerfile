FROM rabbitmq:3.8.3-management
ENV container docker
RUN yum -y update
RUN yum swap -y fakesystemd systemd && yum clean all
RUN yum install -y epel-release && yum clean all
RUN yum install -y openssh-server passwd iproute chrony tzdata && yum clean all
ADD chrony.conf /etc/
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN sed -ri 's/ChallengeResponseAuthentication yes/#ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/GSSAPICleanupCredentials no/#CGSSAPICleanupCredentials no/' /etc/ssh/sshd_config
RUN systemctl enable chronyd.service
RUN systemctl enable sshd.service
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo root:aslinux | chpasswd
EXPOSE 5672
EXPOSE 15672
EXPOSE 22
CMD /sbin/init