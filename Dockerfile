FROM ubuntu:16.04

USER root

RUN apt-get update && apt-get install \
        unzip \
        wget \
        awscli \
        openssh-client \
        curl -y
RUN wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
RUN unzip terraform_0.11.3_linux_amd64.zip
RUN mv terraform /usr/local/bin/

RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "ubuntu" ubuntu
USER 1001
RUN chmod -R u+w,g+w /home/ubuntu