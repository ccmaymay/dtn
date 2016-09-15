.PHONY: help all
all:

help:
	@echo "A simple Makefile to help with setting up Docker images for Globus Endpoint Transfers."
	@echo "Known targets:"
	@echo "  all: Create the Dockerfile, build the image and start it."
	@echo "  help: Display this message."
	@echo "  Dockerfile: create a user-specific Dockerfile"
	@echo "  build-img: build the docker image"
	@echo ""
	@echo "Set the directory to mount via variable DIR; this is necessary for transferring existing files from this machine."
	@echo "Change the dockername via DOCKER_NAME (default: `whoami`-dtn"

USER_ID=$(shell id -u)
ME=$(shell whoami)
DIR:=/tmp/$(ME)-xfer
DOCKER_NAME:=$(ME)-dtn

Dockerfile:
	@echo "FROM centos:7" > $@
	@echo "" >> $@
	@echo "ENV uid $(USER_ID)" >> $@
	@echo "" >> $@
	@echo "RUN yum update -y && yum clean all" >> $@
	@echo "RUN yum install -y \\" >> $@
	@echo "        man \\" >> $@
	@echo "        iproute \\" >> $@
	@echo "        iptables \\" >> $@
	@echo "        sudo \\" >> $@
	@echo "        traceroute" >> $@
	@echo "" >> $@
	@echo "RUN useradd -u \$$uid -m -U -s /bin/bash globus" >> $@
	@echo "RUN passwd -l globus" >> $@
	@echo "RUN echo 'globus	ALL=(ALL)	NOPASSWD: ALL' >> /etc/sudoers" >> $@
	@echo "" >> $@
	@echo "ADD bwlimit.bash /home/globus/bwlimit.bash" >> $@
	@echo "ADD container_readme.md /home/globus/container_readme.md" >> $@
	@echo "RUN chmod 755 /home/globus/bwlimit.bash" >> $@
	@echo "RUN chown globus:globus /home/globus/bwlimit.bash" >> $@
	@echo "" >> $@
	@echo "USER globus" >> $@
	@echo "ENV USER globus" >> $@
	@echo "WORKDIR /home/globus" >> $@
	@echo "RUN curl -o globusconnectpersonal-latest.tgz https://s3.amazonaws.com/connect.globusonline.org/linux/stable/globusconnectpersonal-latest.tgz" >> $@
	@echo "RUN tar -xzf globusconnectpersonal-latest.tgz" >> $@
	@echo "RUN echo \"Please ensure that you have created an endpoint: https://www.globus.org/app/endpoints/create-gcp\"" >> $@
	@echo "RUN echo \"\"" >> $@
	@echo "RUN cat container_readme.md" >> $@

container_readme.md:
	@echo "Inside the container, first enable the bandwidth limit:" > $@
	@echo "\`\`\`"  >> $@
	@echo "sudo ./bwlimit.bash 100mbit"  >> $@
	@echo "\`\`\`"  >> $@
	@echo "Make sure you know your Personal endpoing id (you can create one at https://www.globus.org/app/endpoints/create-gcp)"  >> $@
	@echo "then set up and start a new Globus personal endpoint (version x.y.z):"  >> $@
	@echo "\`\`\`"  >> $@
	@echo "cd globusconnectpersonal-x.y.z"  >> $@
	@echo "./globusconnect -setup \$$endpoint_id"  >> $@
	@echo "./globusconnect -start -restrict-paths /xfer"  >> $@

.PHONY: build-img
build-img: Dockerfile container_readme.md
	docker build -t $(DOCKER_NAME) .

.PHONY: run
run:
	mkdir -p $(DIR)
	docker run -v $(DIR):/xfer:z --cap-add=NET_ADMIN -it $(DOCKER_NAME)

all: build-img run
