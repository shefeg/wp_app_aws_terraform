#!/bin/bash

git clone -b wp-app --single-branch https://github.com/shefeg/chef-repo.git
cd chef-repo

NODE="$(sudo knife node list -z 2>&1 | tail -1)"

sudo knife node run_list add $NODE wp-app::default -z
chef-client -z