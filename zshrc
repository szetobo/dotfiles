[[ -z $(dpkg -l | grep htop)       ]] && sudo apt-get install -y htop
[[ -z $(dpkg -l | grep git-extras) ]] && sudo apt-get install -y git-extras

if [[ ! -d ~/.dotfiles ]]; then
  git clone git://github.com/szetobo/dotfiles.git ~/.dotfiles

  ln -sf ~/.dotfiles/gemrc               ~/.gemrc
  ln -sf ~/.dotfiles/inputrc             ~/.inputrc
  ln -sf ~/.dotfiles/psqlrc              ~/.psqlrc
  ln -sf ~/.dotfiles/tigrc               ~/.tigrc
  ln -sf ~/.dotfiles/tmux.conf           ~/.tmux.conf
  ln -sf ~/.dotfiles/vimrc.local         ~/.vimrc.local
  ln -sf ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local

  ln -sf ~/.dotfiles/zshrc               ~/.zshrc

  mkdir -p ~/.psql_history
fi

if [[ ! -d ~/.maximum-awesome ]]; then
  git clone git://github.com/square/maximum-awesome.git ~/.maximum-awesome
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.maximum-awesome/vim/bundle/Vundle.vim

  ln -sf ~/.maximum-awesome/vim ~/.vim
  ln -sf ~/.maximum-awesome/vimrc ~/.vimrc
  ln -sf ~/.maximum-awesome/vimrc.bundles ~/.vimrc.bundles

  vim +BundleInstall +qall
fi

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  export ZPLUG_HOME=~/.zplug
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zaw"
zplug "b4b4r07/enhancd",  use:init.sh
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf

zplug "lib/compfix",              from:oh-my-zsh, defer:0
zplug "lib/directories",          from:oh-my-zsh, defer:0
zplug "lib/grep",                 from:oh-my-zsh, defer:0
zplug "lib/misc",                 from:oh-my-zsh, defer:0
zplug "lib/termsupport",          from:oh-my-zsh, defer:0
zplug "lib/theme-and-appearance", from:oh-my-zsh, defer:0

zplug "plugins/git",     from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/chruby",  from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/rails",   from:oh-my-zsh

# zplug 'zimframework/git', use:init.sh

zplug 'dracula/zsh', as:theme

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-autosuggestions",          defer:3

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
  # printf "Install? [y/N]: "
  # if read -q; then
  #   echo; zplug install
  # fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

if zplug check zsh-users/zsh-autosuggestions; then
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
fi

if zplug check zsh-users/zsh-history-substring-search; then
  bindkey '\eOA' history-substring-search-up
  bindkey '\eOB' history-substring-search-down
fi


#
# directory shortcut
#
p()  { cd ~/proj/$1;}
h()  { cd ~/$1;}
vm() { cd ~/vagrant/$1;}

compctl -W ~/proj -/ p
compctl -W ~ -/ h
compctl -W ~/vagrant -/ vm


#
# pairing session shortcut
#
pairg() { ssh -t $1 ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' -p $2 -t vagrant@localhost 'tmux attach' }
pairh() { ssh -S none -o 'ExitOnForwardFailure=yes' -R $2\:localhost:$2 -t $1 'watch -en 10 who' }


#
# tmux shortcut
#
tx() {
  if ! tmux has-session -t work 2> /dev/null; then
    tmux new -s work -d;
    # tmux splitw -h -p 40 -t work;
    # tmux select-p -t 1;
  fi
  tmux attach -t work;
}
txtest() {
  if ! tmux has-session -t test 2> /dev/null; then
    tmux new -s test -d;
  fi
  tmux attach -t test;
}
txpair() {
  SOCKET=/home/share/tmux-pair/default
  if ! tmux -S $SOCKET has-session -t pair 2> /dev/null; then
    tmux -S $SOCKET new -s pair -d;
    # tmux -S $SOCKET send-keys -t pair:1.1 "chmod 1777 " $SOCKET C-m "clear" C-m;
  fi
  tmux -S $SOCKET attach -t pair;
}


#
# aliases
#
alias px='ps aux'
alias vt='vim -c :CtrlP'

# alias reload='. ~/.zshrc'

# if (uname -a | grep -i darwin > /dev/null); then
#   alias ls='ls -FG'
# else
#   alias ls='ls --color=tty -F'
# fi
# alias la='ls -a'
# alias lla='ll -a'
alias sa='ssh-add'
alias salock='ssh-add -x'
alias saunlock='ssh-add -X'

alias agi='ag -i'
alias agr='ag --ruby'
alias agri='ag --ruby -i'

alias -g G='| ag'
alias -g P='| less'
alias -g WC='| wc -l'
alias -g RE='RESCUE=1'

alias va=vagrant
alias vsh='va ssh'
alias vsf='va ssh -- -L 0.0.0.0:8080:localhost:80 -L 1080:localhost:1080'
alias vup='va up'
alias vsup='va suspend'
alias vhalt='va halt'


#
# environment variables
#
export EDITOR=vim
export VISUAL=vim
export PAGER=less
