FROM centos:7

ENV uid 1000

RUN yum update -y && yum clean all
RUN yum install -y \
        man \
        iproute \
        iptables \
        sudo \
        traceroute

RUN useradd -u $uid -m -U -s /bin/bash globus
RUN passwd -l globus
RUN echo 'globus	ALL=(ALL)	NOPASSWD: ALL' >> /etc/sudoers

ADD bwlimit.bash /home/globus/bwlimit.bash
RUN chmod 755 /home/globus/bwlimit.bash
RUN chown globus:globus /home/globus/bwlimit.bash

USER globus
WORKDIR /home/globus
RUN curl -o globusconnectpersonal-latest.tgz https://s3.amazonaws.com/connect.globusonline.org/linux/stable/globusconnectpersonal-latest.tgz
RUN tar -xzf globusconnectpersonal-latest.tgz
