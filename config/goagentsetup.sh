#!/bin/bash

sudo yum update
curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo
sudo yum install -y java-1.8.0-openjdk
mkdir /var/go
sudo yum install -y go-agent
#sed -i.bak 's/^GO_SERVER_URL=https:\/\/127.0.0.1:8154\/go/GO_SERVER_URL=https://$GO-SERVER:8154/go/g' /etc/yum.repos.d/CentOS-Base.repo;
sudo /etc/init.d/go-agent start
