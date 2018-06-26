#!/usr/bin/env bash
#
# bootstrap script for gitlab-runner on aws ec2
#

sudo -i

source /etc/os-release

if [[ "$NAME" = "Ubuntu" && "$VERSION_ID" = "16.04" ]]; then
  apt update

  if [[ "$LANG" != "zh_TW.utf8" ]]; then
    # setup proper locale
    locale-gen zh_TW.utf8 en_HK.utf8
    update-locale LC_ALL=zh_TW.utf8 LANG=zh_TW.utf8
  fi

  timedatectl set-timezone Asia/Taipei

  # install common tools
  apt -y install wget curl htop silversearcher-ag

  # upgrade installed packages & remove obsoleted one
  apt -y upgrade
  apt -y autoremove

  curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
  apt-get install gitlab-runner
  gitlab-runner register --non-interactive --name runnerx --url https://gitlab.abagile.com --registration-token XXX --executor shell

  apt-get install -y build-essential
  apt-get install -y libssl-dev libreadline-dev zlib1g-dev libpq-dev
  apt-get install -y postgresql-9.5 postgresql-contrib-9.5

  su - postgres -c 'createuser -s gitlab-runner'
  createdb angel_test

  su - gitlab-runner -c 'git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0'
  # add to .bashrc
fi
