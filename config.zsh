
#
# directory shortcut
#
p() {cd ~/proj/$1;}
h() {cd ~/$1;}

compctl -W ~/proj -/ p
compctl -W ~ -/ h


#
# misc aliases or functions
#
alias reload='. ~/.zshrc'

alias px='ps aux'

alias ls='ls --color=tty -F'
alias la='ls -a'
alias lla='ll -a'
alias sa='ssh-add'
alias salock='ssh-add -x'
alias saunlock='ssh-add -X'

alias open='xdg-open'

alias ack='ag'
alias ackr='ack --ruby'
alias acki='ack -i'
alias ackri='ack --ruby -i'

alias -g G='| ack'
alias -g P='| less'
alias -g WC='| wc -l'


#
# git config and aliases
#
alias gcl='git clone'
alias gls='git ls-files'
alias gdf='git diff'
alias gsa='git stash'
alias glo='git log'
alias glgp='git log -p'

alias gpa="git co master && git pull && git remote prune origin"


#
# tmux alias
#
alias tmux='tmux -2'
tx() {
  if ! tmux has-session -t work; then
    tmux new -s work -d;
    tmux splitw -v -p 70 -t work;
  fi
  tmux attach -t work;
}
txtest() {
  if ! tmux has-session -t test; then
    tmux new -s test -d;
  fi
  tmux attach -t test;
}
txpair() {
  if ! tmux -S /tmp/pair has-session -t pair 2> /dev/null; then
    tmux -S /tmp/pair new -s pair -d;
    tmux -S /tmp/pair send-keys -t pair:1.1 "chmod 1777 /tmp/pair" C-m "clear" C-m;
  fi
  tmux -S /tmp/pair attach -t pair;
}


#
# further customize vi-mode key bindings
#
bindkey ' ' magic-space

bindkey -M vicmd "^[[H"  beginning-of-line
bindkey -M vicmd "^[OH"  beginning-of-line
bindkey -M vicmd "^[[1~" beginning-of-line
bindkey -M vicmd "^[[F"  end-of-line
bindkey -M vicmd "^[OF"  end-of-line
bindkey -M vicmd "^[[4~" end-of-line
bindkey -M vicmd "^[OC" forward-word
bindkey -M vicmd "^[OD" backward-word
bindkey -M vicmd "^?"  backward-delete-char
bindkey -M vicmd "^[[3~"  delete-char
bindkey -M vicmd "^[3;5~" delete-char
bindkey -M vicmd "\e[3~"  delete-char

bindkey -M viins "^L" clear-screen
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins "^[[H"  beginning-of-line
bindkey -M viins "^[OH"  beginning-of-line
bindkey -M viins "^[[1~" beginning-of-line
bindkey -M viins "^[[F"  end-of-line
bindkey -M viins "^[OF"  end-of-line
bindkey -M viins "^[[4~" end-of-line
bindkey -M viins "^[OC" forward-word
bindkey -M viins "^[OD" backward-word
bindkey -M vicmd "^?"  backward-delete-char
bindkey -M viins "^[[3~"  delete-char
bindkey -M viins "^[3;5~" delete-char
bindkey -M viins "\e[3~"  delete-char


# expand ... to /..
#
#
function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path
bindkey -M viins "." expand-dot-to-parent-directory-path
bindkey -M isearch . self-insert 2> /dev/null


#
# editors
#
export EDITOR=vim
export VISUAL=vim
export PAGER=less

alias vi='vim'


#
# ruby 1.9.3 performance patch settings, not sure if it has any effect on ruby 2.0
#
# export RUBY_GC_MALLOC_LIMIT=1000000000
# export RUBY_HEAP_FREE_MIN=500000
# export RUBY_HEAP_MIN_SLOTS=40000
# export RUBY_HEAP_SLOTS_INCREMENT=1000000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1


#
# rails development aliases
#
alias lgc='for f in $(ls log/*.log); do cat /dev/null >! $f; done'
alias kuc='[[ -f tmp/pids/unicorn.pid ]] && kill `cat tmp/pids/unicorn.pid`'
alias uc='[[ -f config/unicorn.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec unicorn -c $PWD/config/unicorn.rb -D'
alias pa='[[ -f config/puma.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec puma -C $PWD/config/puma.rb -d'
alias kpa='[[ -f tmp/pids/puma.pid ]] && kill `cat tmp/pids/puma.pid`'


#
# chruby
#
if [ -f /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

