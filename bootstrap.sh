#!/usr/bin/env bash
#
# bootstrap script, assumed to be run as root
#
# to used it as vagrant provision shell script, invoke with parameter 'vagrant'
#

if (uname -a | grep -i ubuntu > /dev/null); then
  # update package list
  sed -i 's/us\.archive\.ubuntu\.com/ftp\.cuhk\.edu\.hk\/pub\/Linux/g' /etc/apt/sources.list
  sed -i 's/security\.ubuntu\.com/ftp\.cuhk\.edu\.hk\/pub\/Linux/g' /etc/apt/sources.list
  apt-get update
  # apt-get -y upgrade

  # get latest git-core repository
  apt-get -y install python-software-properties
  add-apt-repository -y ppa:git-core/ppa || add-apt-repository ppa:git-core/ppa
  apt-get update

  # install required packages
  apt-get -y install build-essential git-core tig wget curl htop \
    rake exuberant-ctags vim-gtk ack-grep zsh
  apt-get -y install bison openssl libssl-dev libxslt1.1 libxslt1-dev \
    libxml2 libxml2-dev libffi-dev libyaml-dev libxslt-dev autoconf \
    libc6-dev libreadline6-dev zlib1g zlib1g-dev \
    ruby-dev libopenssl-ruby

elif (uname -a | grep -i arch > /dev/null); then
  # update package list
  pacman -Sy
  pacman --noconfirm --needed -S base-devel git tig wget curl htop \
    ruby vim-nox ctags ack zsh the_silver_searcher
  pacman --noconfirm --needed -S bison openssl libxslt libxml2 libyaml libffi \
    autoconf readline zlib

fi

#
# install chruby
#
if [ ! -d /usr/local/share/chruby ]; then
  wget -O /tmp/chruby-0.3.4.tar.gz https://github.com/postmodern/chruby/archive/v0.3.4.tar.gz
  tar -C /tmp -xvzf /tmp/chruby-0.3.4.tar.gz
  cd /tmp/chruby-0.3.4
  make install
fi

#
# install ruby-install
#
if [ ! -x /usr/local/bin/ruby-install ]; then
  wget -O /tmp/ruby-install-0.3.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.3.0.tar.gz
  tar -C /tmp -xzvf /tmp/ruby-install-0.3.0.tar.gz
  cd /tmp/ruby-install-0.3.0/
  make install
fi


if [[ $1 == "vagrant" ]]; then
  su -l -c '[ ! -d ~/.dotfiles ] && git clone git://github.com/szetobo/dotfiles.git ~/.dotfiles; ~/.dotfiles/run.sh install' vagrant
fi

exit 0

