FROM ubuntu:latest

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

ARG user=jenkins
ARG group=jenkins
ARG uid=112
ARG gid=117

ENV JENKINS_HOME /var/lib/jenkins

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}