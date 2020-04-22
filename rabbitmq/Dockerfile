FROM rabbitmq:3.8.3-management
ENV container docker
RUN apt-get  update
RUN apt-get -y install wget
RUN apt-get -y install gnupg
RUN echo "deb http://packages.dotdeb.org wheezy all" > /etc/apt/sources.list.d/dotdeb.list
RUN echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list.d/dotdeb.list
RUN cd /tmp
RUN wget http://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg
#RUN apt-get -y install systemd
RUN apt-get -y install openssh-server passwd iproute2 chrony tzdata
ADD chrony.conf /etc/chrony/chrony.conf
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN sed -ri 's/ChallengeResponseAuthentication yes/#ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config 
RUN sed -ri 's/GSSAPICleanupCredentials no/#CGSSAPICleanupCredentials no/' /etc/ssh/sshd_config
RUN systemctl enable chrony
RUN systemctl enable ssh
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo root:aslinux | chpasswd
EXPOSE 5672 15672 22
CMD /sbin/init