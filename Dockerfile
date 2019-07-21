FROM scratch
ADD ubuntu.tar.xz /

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="UBUNTU Base Image" \
    org.label-schema.vendor="UBUNTU" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20181204"

CMD ["/bin/bash"]

ADD docker-ce_17.06.1_ce-0_ubuntu_amd64.deb /
cd /var/lib/dpkg 
RUN mv info info.bak 
RUN mkdir info 
RUN apt-get upgrade
RUN apt-get install -y docker-ce_17.06.1_ce-0_ubuntu_amd64.deb

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:123456' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD  ["/usr/sbin/sshd", "-D"]