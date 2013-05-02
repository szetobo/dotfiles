#!/usr/bin/env bash

link_file() {
  [ -f $2 ] && mv -f $2 $2\.backup
  ln -sf $1 $2
}

unlink_file() {
  if [ -L $1 ]; then
    rm -f $1
    [[ -f $1\.backup || -d $1\.backup ]] && mv -f $1\.backup $1
  fi
}

link_files() {
  # symlink configuration files
  link_file $1/config.zsh ~/.oh-my-zsh/custom/config.zsh
  link_file $1/gemrc ~/.gemrc
  link_file $1/gitconfig ~/.gitconfig
  link_file $1/tmux.conf ~/.tmux.conf
  link_file $1/vimrc.before ~/.vimrc.before
  link_file $1/vimrc.after ~/.vimrc.after

  [ ! -f ~/.zshrc ] && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  [ ! -L ~/.vimrc ] && ln -s ~/.vim/janus/vim/vimrc ~/.vimrc
  [ ! -L ~/.gvimrc ] && ln -s ~/.vim/janus/vim/gvimrc ~/.gvimrc
}

unlink_files() {
  # unlink configuration files
  unlink_file ~/.oh-my-zsh/custom/config.zsh
  unlink_file ~/.gemrc
  unlink_file ~/.gitconfig
  unlink_file ~/.tmux.conf
  unlink_file ~/.vimrc.before
  unlink_file ~/.vimrc.after
}


SCRIPT_DIR=`readlink -f $(dirname $0)`
case "$1" in
  install)
    # install oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
      git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
      [ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup
    else
      echo 'oh-my-zsh already installed, skip ...'
    fi

    # install janus
    if [ ! -d ~/.vim/janus ]; then
      wget -O - https://raw.github.com/carlhuda/janus/master/bootstrap.sh | bash
    else
      echo 'janus already installed, skip ...'
    fi
    if [ ! -d ~/.janus ]; then
      mkdir -p ~/.janus
      git clone git://github.com/sjbach/lusty.git ~/.janus/lusty
      git clone git://github.com/godlygeek/tabular ~/.janus/tabular
      git clone git://github.com/nathanaelkane/vim-indent-guides ~/.janus/vim-indent-guides
      git clone git://github.com/Lokaltog/vim-powerline ~/.janus/vim-powerline
      git clone git://github.com/tpope/vim-rails ~/.janus/vim-rails
    else
      echo 'janus custom plugins already installed, skip ...'
    fi

    link_files $SCRIPT_DIR
    echo "installation completed"
    ;;

  relink)
    link_files $SCRIPT_DIR
    echo "configuration symlinks updated"
    ;;

  unlink)
    unlink_files $SCRIPT_DIR
    echo "configuration symlinks removed"
    ;;

  uninstall)
    # move oh-my-zsh to backup directory
    [ -d ~/.oh-my-zsh ] && mv ~/.oh-my-zsh $SCRIPT_DIR/backup/
    mv -f ~/.zshrc $SCRIPT_DIR/backup/
    [ -f ~/.zshrc.backup ] && mv -f ~/.zshrc.backup ~/.zshrc

    # move janus to backup directory
    [ -d ~/.vim/janus ] && mv ~/.vim $SCRIPT_DIR/backup/
    [ -d ~/.janus ] && mv ~/.janus $SCRIPT_DIR/backup/
    unlink_file ~/.vimrc
    unlink_file ~/.gvimrc

    unlink_files $SCRIPT_DIR
    echo "remove $SCRIPT_DIR to completely uninstall everything"
    ;;

  *)
    echo "Usage: $SCRIPT_DIR/run.sh {install|relink|unlink|uninstall}"
    ;;
esac

exit 0

