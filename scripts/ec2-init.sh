#!/usr/bin/env bash
#
# bootstrap script for aws ec2
#

sudo -i

source /etc/os-release

if [[ "$NAME" = "Ubuntu" && "$VERSION_ID" = "16.04" ]]; then
  apt update

  if [[ "$LANG" != "zh_TW.utf8" ]]; then
    # setup proper locale
    locale-gen zh_TW.utf8 en_HK.utf8
    update-locale LC_ALL=zh_TW.utf8 LANG=zh_TW.utf8
    # export LC_ALL=zh_TW.UTF8
    # export LANG=zh_TW.UTF8
  fi

  timedatectl set-timezone Asia/Taipei

  # if [[ "`cat /etc/timezone`" != "Asia/Taipei" ]]; then
  #   # set local timezone
  #   echo 'Asia/Taipei' | tee /etc/timezone
  #   dpkg-reconfigure --frontend noninteractive tzdata
  # fi

  # install common tools
  apt -y install wget curl htop silversearcher-ag

  # upgrade installed packages & remove obsoleted one
  apt -y upgrade
  apt -y autoremove

elif [[ "$NAME" = "Ubuntu" && "$VERSION_ID" = "14.04" ]]; then
  apt-get update

  if [[ "$LANG" != "en_HK.utf8" ]]; then
    # setup proper locale
    locale-gen en_HK.utf8 zh_TW.utf8
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

  # upgrade installed packages & remove obsoleted one
  apt-get -y upgrade
  apt-get -y autoremove
fi
