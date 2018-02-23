#!/usr/bin/env bash

git clone -b wp-app --single-branch https://github.com/shefeg/chef-repo.git; cd chef-repo || cd chef-repo; git pull origin wp-app
sleep 5 # hack...
NODE="$(sudo knife node list -z 2>&1 | tail -1)"
sudo knife node run_list add $NODE wp-app::default -z
sudo chef-client -z