#!/usr/bin/env bash
#
# docker installation script
#

# Install packages to allow apt to use a repository over HTTPS
apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add docker stable apt repository
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# Install docker-ce edition
apt-get update
apt-get -y install docker-ce
