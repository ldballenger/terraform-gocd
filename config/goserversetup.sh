#!/bin/bash

sudo yum update
curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo
sudo yum install -y java-1.8.0-openjdk
mkdir /var/go
sudo yum install -y go-server
sudo /etc/init.d/go-server start
