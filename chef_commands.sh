#!/usr/bin/env bash

[[ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]] || sudo yum install -y install git
cd ~
git clone -b master --single-branch https://github.com/shefeg/chef-repo.git && cd ~/chef-repo || \
cd ~/chef-repo && git pull origin master
[ -f /var/www/html/wp-config.php ] || sudo chef-client -z
NODE="$(sudo knife node list -z 2>&1 | tail -1)"
sudo knife node run_list add $NODE wp-app::default -z
sudo chef-client -z