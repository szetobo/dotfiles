#!/usr/bin/env bash
#
# docker installation script
#

# Add Docker’s official GPG key
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash

# Install docker-ce edition
apt-get update
apt-get -y install gitlab-runner
