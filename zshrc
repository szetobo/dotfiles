# shell environment initialization {{{

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

# }}}


# zplug {{{

# install zplug, if necessary
if [[ ! -d ~/.zplug ]]; then
  export ZPLUG_HOME=~/.zplug
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source ~/.zplug/init.zsh

zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/chruby",  from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/rails",   from:oh-my-zsh

zplug "b4b4r07/enhancd", use:init.sh
zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"

zplug "zsh-users/zsh-autosuggestions", defer:3

# zim {{{
zplug "zimframework/zim", as:plugin, use:"init.zsh", hook-build:"ln -sf $ZPLUG_REPOS/zimframework/zim ~/.zim"

zmodules=(directory environment git history input spectrum ssh utility meta \
          syntax-highlighting history-substring-search prompt completion)

zprompt_theme='eriner'
zhighlighters=(main brackets pattern cursor root)
# }}}

if ! zplug check --verbose; then
  zplug install
fi

zplug load #--verbose

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

source ~/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh
source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

export FZF_COMPLETION_TRIGGER=';'
export FZF_TMUX=1

# }}}


# customization {{{

# directory shortcut {{{
p()  { cd ~/proj/$1;}
h()  { cd ~/$1;}
vm() { cd ~/vagrant/$1;}

compctl -W ~/proj -/ p
compctl -W ~ -/ h
compctl -W ~/vagrant -/ vm
# }}}

# development shortcut {{{
alias pa!='[[ -f config/puma.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec puma -C $PWD/config/puma.rb'
alias pa='[[ -f config/puma.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec puma -C $PWD/config/puma.rb -d'
alias kpa='[[ -f tmp/pids/puma.state ]] && pumactl -S tmp/pids/puma.state stop'

alias mc='bundle exec mailcatcher --http-ip 0.0.0.0'
alias kmc='pkill -fe mailcatcher'
alias sk='[[ -f config/sidekiq.yml ]] && bundle exec sidekiq -C $PWD/config/sidekiq.yml -d'
alias ksk='pkill -fe sidekiq'

pairg() { ssh -t $1 ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' -p $2 -t vagrant@localhost 'tmux attach' }
pairh() { ssh -S none -o 'ExitOnForwardFailure=yes' -R $2\:localhost:$2 -t $1 'watch -en 10 who' }

cop() {
  local exts=('rb,thor,jbuilder')
  local excludes=':(top,exclude)db/schema.rb'
  local extra_options='--display-cop-names --rails'

  if [[ $# -gt 0 ]]; then
    local files=$(eval "git diff $@ --name-only -- *.{$exts} $excludes")
  else
    local files=$(eval "git status --porcelain -- *.{$exts} $excludes | sed -e '/^\s\?[DRC] /d' -e 's/^.\{3\}//g'")
  fi

  if [[ -n "$files" ]]; then
    echo $files | xargs bundle exec rubocop `echo $extra_options`
  else
    echo "Nothing to check. Write some *.{$exts} to check.\nYou have 20 seconds to comply."
  fi
}
# }}}

# tmux shortcut {{{
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
fixssh() {
  if [ "$TMUX" ]; then
    export $(tmux showenv SSH_AUTH_SOCK)
  fi
}
# }}}

# aliases {{{
alias px='ps aux'
alias vt='vim -c :CtrlP'

alias sa='ssh-add'
alias salock='ssh-add -x'
alias saunlock='ssh-add -X'

alias agi='ag -i'
alias agr='ag --ruby'
alias agri='ag --ruby -i'

alias -g G='| ag'
alias -g P='| $PAGER'
alias -g WC='| wc -l'
alias -g RE='RESCUE=1'

alias va=vagrant
alias vsh='va ssh'
alias vsf='va ssh -- -L 0.0.0.0:8080:localhost:80 -L 1080:localhost:1080'
alias vup='va up'
alias vsup='va suspend'
alias vhalt='va halt'
# }}}

# environment variables {{{
export EDITOR=vim
export VISUAL=vim
#}}}

# key bindings {{{
bindkey -M vicmd '^a' beginning-of-line
bindkey -M vicmd '^e' end-of-line

bindkey '^f' vi-forward-word
bindkey '^b' vi-backward-word

bindkey '^j' autosuggest-accept

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
# }}}

# }}}
