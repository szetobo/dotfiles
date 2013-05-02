#!/usr/bin/env bash
#
# bootstrap script, assumed to be run as root
#
# to used it as vagrant provision shell script, invoke with parameter 'vagrant'
#

case `lsb_release -is` in
  Ubuntu)
    # update system
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
      rake exuberant-ctags vim-gtk ack-grep zsh htop
    apt-get -y install bison openssl libssl-dev libxslt1.1 libxslt1-dev \
      libxml2 libxml2-dev libffi-dev libyaml-dev libxslt-dev autoconf \
      libc6-dev libreadline6-dev zlib1g zlib1g-dev \
      ruby-dev libopenssl-ruby

     ;;

   ManjaroLinux|ArchBang|ArchLinux)
     ;;

   *)
     ;;
esac

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
# install ruby-build
#
if [ ! -x /usr/local/bin/ruby-build ]; then
  git clone https://github.com/sstephenson/ruby-build.git
  cd ruby-build
  ./install.sh
fi

#
# install rubies
#
mkdir -p /opt/rubies
if [ ! -d /opt/rubies/2.0.0-p0 ]; then
  ruby-build 2.0.0-p0 /opt/rubies/2.0.0-p0
fi

# build 1.9.3-p392 with performance patch
VERSION="1.9.3-p392"
if [ ! -d /opt/rubies/$VERSION ]; then
  wget -O /tmp/$VERSION https://raw.github.com/gist/5256849/2-$VERSION-patched.sh
  ruby-build /tmp/$VERSION /opt/rubies/$VERSION
fi

if [[ $1 == "vagrant" ]]; then
  su -l -c '[ ! -d ~/.dotfiles ] && git clone git://github.com/szetobo/dotfiles.git ~/.dotfiles; ~/.dotfiles/run.sh install' vagrant
fi

exit 0

