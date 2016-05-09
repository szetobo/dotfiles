#!/usr/bin/env bash
#
# bootstrap script for digital ocean
#

sudo -i

source /etc/os-release

if [[ "$NAME" = "Ubuntu" && "$VERSION_ID" = "14.04" ]]; then
  apt-get update

  if [[ "$LANG" != "en_HK.utf8" ]]; then
    # setup proper locale
    locale-gen en_HK.utf8
    update-locale LC_ALL=en_HK.utf8 LANG=en_HK.utf8
    export LC_ALL=en_HK.UTF8
    export LANG=en_HK.UTF8
  fi

  if [[ "`cat /etc/timezone`" != "Asia/Hong_Kong" ]]; then
    # set local timezone
    echo 'Asia/Hong_Kong' | tee /etc/timezone
    dpkg-reconfigure --frontend noninteractive tzdata
  fi

  # install common tools
  apt-get -y install wget curl htop ntp fail2ban silversearcher-ag

  # create new user, login with root should be avoided in most situations
  adduser --gecos "Ubuntu" --disabled-password ubuntu

  # allow user to sudo without password
  touch /etc/sudoers.d/ubuntu
  echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu

  # prepare key-based only login
  mkdir -p /home/ubuntu/.ssh
  chmod 700 /home/ubuntu/.ssh
  cp ~/.ssh/authorized_keys /home/ubuntu/.ssh
  chown -R ubuntu:ubuntu /home/ubuntu/.ssh

  # update sshd config
  sed -i.bak -r \
    -e 's/^#?(PermitRootLogin) yes/\1 without-password/' \
    -e 's/^#?(PasswordAuthentication) yes/\1 no/' \
    -e 's/^#?(X11Forwarding) yes/\1 no/' \
    /etc/ssh/sshd_config
  service ssh restart

  # config fail2ban
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  service fail2ban restart
fi
