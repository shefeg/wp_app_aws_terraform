#!/bin/bash

chefdk_install_ubuntu_16 ()
{
    if [[ ! $(dpkg -l | grep chefdk) ]]; then
        CHEF_PACKAGE_URL="https://packages.chef.io/files/stable/chefdk/2.4.17/ubuntu/16.04/chefdk_2.4.17-1_amd64.deb"
        wget -nc $CHEF_PACKAGE_URL
        dpkg -i $(echo "$CHEF_PACKAGE_URL" | sed 's/^.*\(chef\)/\1/')
        [ ! -f ~/.profile ] && touch ~/.profile
        echo 'eval "$(chef shell-init bash)"' >> ~/.profile && source ~/.profile > /dev/null
        chef verify
    else
        echo "CHEF DK IS ALREADY INSTALLED"
    fi
}

chefdk_install_centos_7 ()
{
    if [[ ! $(sudo rpm -qa | grep chefdk) ]]; then
        CHEF_PACKAGE_URL="https://packages.chef.io/files/stable/chefdk/2.4.17/el/7/chefdk-2.4.17-1.el7.x86_64.rpm"
        sudo rpm -Uvh $CHEF_PACKAGE_URL
        [ ! -f ~/.bash_profile ] && sudo touch ~/.bash_profile
        sudo echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile && sudo source ~/.bash_profile > /dev/null
        sudo chef verify
    else
        echo "CHEF DK IS ALREADY INSTALLED"
    fi
}

if [ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]; then
    apt-get update
    apt-get -y install wget
    apt-get -y install git
    chefdk_install_ubuntu_16
else
    sudo yum install -y git
    chefdk_install_centos_7
fi