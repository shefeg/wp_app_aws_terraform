FROM jenkinsci/slave:latest

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
RUN terraform --version