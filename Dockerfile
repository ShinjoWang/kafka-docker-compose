FROM centos:7.9.2009

RUN yum install -y wget
RUN wget --no-check-certificate https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/repo/epel-7/jsynacek-systemd-backports-for-centos-7-epel-7.repo -O /etc/yum.repos.d/jsynacek-systemd-centos-7.repo
RUN yum install -y systemd; \
		yum clean all

RUN	yum install -y openssh-server sudo; \
		yum clean all
RUN systemctl enable sshd
RUN echo 'root:asdf' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/init"]
