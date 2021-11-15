#!/usr/bin/env zsh

mkdir -p ~/.psql_history

if [[ "`uname -s`" == "Darwin" ]]; then

  brew install asdf stow fzf nvim bat fd autojump lazygit exa just

  cd ~/.dotfiles/stow
  for s in *; do stow -t ~ $s; done

  nvim +PlugInstall +qall

else

  cd ~/.dotfiles/stow
  for s in *; do stow -t ~ $s; done

  if [ ! -d ~/.fzf ]; then
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    yes n | ~/.fzf/install
  fi

  if [ ! `whence hstr` ]; then
    sudo add-apt-repository -y ppa:ultradvorka/ppa
    sudo apt update
    sudo apt install hstr
    # hstr --show-configuration >> ~/.zshrc
  fi

  vi +PlugInstall +qall

fi
