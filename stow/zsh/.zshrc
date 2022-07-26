. ~/.zplugin

# customization {{{

if [[ "`uname -s`" == "Darwin" ]]; then
  export LANG=C
fi

# directory shortcut {{{
p()  { cd ~/proj/$1;}
h()  { cd ~/$1;}
vm() { cd ~/vagrant/$1;}
cdpath=(~ ~/proj)

compctl -W ~/proj -/ p
compctl -W ~ -/ h
compctl -W ~/vagrant -/ vm
# }}}

# development shortcut {{{
alias pa!='[[ -f config/puma.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec puma -C $PWD/config/puma.rb'
alias pa='[[ -f config/puma.rb ]] && RAILS_RELATIVE_URL_ROOT=/`basename $PWD` bundle exec puma -C $PWD/config/puma.rb -d'
alias kpa='[[ -f tmp/pids/puma.state ]] && bundle exec pumactl -S tmp/pids/puma.state stop'
# alias kpa='[[ -f tmp/pids/puma.pid ]] && kill `cat tmp/pids/puma.pid`'

alias mc='mailcatcher --http-ip 0.0.0.0'
alias kmc='pkill -fe mailcatcher'
alias sk='[[ -f config/sidekiq.yml ]] && bundle exec sidekiq -C $PWD/config/sidekiq.yml -d'
alias ksk='pkill -fe sidekiq'

pairg() { ssh -t $1 ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' -p $2 -t ${3:-vagrant}@localhost 'tmux attach' }
pairh() { ssh -S none -o 'ExitOnForwardFailure=yes' -R $2\:localhost:22 -t $1 'watch -en 10 who' }

cop() {
  local exts=('rb,thor,jbuilder')
  local excludes=':(top,exclude)db/schema.rb'
  local extra_options='--display-cop-names --rails'

  if [[ $# -gt 0 ]]; then
    local files=$(eval "git diff $@ --name-only -- \*.{$exts} '$excludes'")
  else
    local files=$(eval "git status --porcelain -- \*.{$exts} '$excludes' | sed -e '/^\s\?[DRC] /d' -e 's/^.\{3\}//g'")
  fi
  # local files=$(eval "git diff --name-only -- \*.{$exts} '$excludes'")

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
alias g='git'

if [[ "`uname -s`" == "Darwin" ]]; then
  alias vi='nvim'
  alias vim='vi'
  alias nvi='XDG_CONFIG_HOME=~/.dev/config XDG_DATA_HOME=~/.dev/data XDG_CACHE_HOME=~/.dev/cache nvim'
  # if [ `whence gls` > /dev/null ]; then
  #   alias ls='gls --group-directories-first --color=auto'
  # fi
fi

# alias emacs='emacsclient -t -a "emacs"'
alias emacs='open -a /Applications/Emacs.app'

alias ls='exa --group-directories-first'
alias l='ls -la'

alias px='ps aux'
alias vt='vi -c :CtrlP'
alias vl='vi -c :CtrlPMRU'
alias v.='vi .'

alias sa='ssh-add'
alias salock='ssh-add -x'
alias saunlock='ssh-add -X'

alias agi='ag -i'
alias agiw='ag -i -w'
alias agr='ag --ruby'
alias agri='ag --ruby -i'

alias rgi='rg -i'
alias rgiw='rg -iw'

alias -g G='| rg'
alias -g P='| $PAGER'
alias -g WC='| wc -l'
alias -g RE='RESCUE=1'

alias rc='bin/rails console'
alias rr='bin/rake routes'
alias rdm='bin/rake db:migrate'
alias rdr='bin/rake db:rollback'
alias rdms='bin/rake db:migrate:status'

alias va=vagrant
# alias vsh='va ssh'
# alias vsf='va ssh -- -L 0.0.0.0:8080:localhost:80 -L 1080:localhost:1080'
alias vsh='ssh gko.abagile.aws.kr'
alias vsf='vsh -L 0.0.0.0:8080:localhost:80 -L 1080:localhost:1080'
alias vup='va up'
alias vsup='va suspend'
alias vhalt='va halt'

alias zshrc='vi ~/.zshrc'
alias vimrc='vi ~/.config/nvim/init.lua'

alias cat=bat

alias apb=ansible-playbook
# }}}

# environment variables {{{
if [ `whence nvim` > /dev/null ]; then
  export EDITOR=nvim
  export VISUAL=nvim
else
  export EDITOR=vi
  export VISUAL=vi
fi
#}}}

# key bindings {{{
bindkey -M vicmd '^a' beginning-of-line
bindkey -M vicmd '^e' end-of-line

bindkey '^[f' vi-forward-word
bindkey '^[b' vi-backward-word

bindkey '^o' autosuggest-accept

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
# }}}

# export fpath=(~/.config/exercism/functions $fpath)
# autoload -U compinit && compinit

# export PATH=$PATH:/usr/local/opt/ansible@2.9/bin:/usr/local/opt/erlang@23/bin:/usr/local/sbin:~/bin:/snap/bin
# }}}

if [[ "`uname -s`" == "Darwin" ]]; then
  [ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh
  [ -f $(brew --prefix asdf)/libexec/asdf.sh ] && . $(brew --prefix asdf)/libexec/asdf.sh
  export HOMEBREW_NO_AUTO_UPDATE=1
else
  [ -f ~/.asdf/asdf.sh ] && source ~/.asdf/asdf.sh && source "$HOME/.asdf/completions/asdf.bash"
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.ssh/id_pair ] && ssh-add ~/.ssh/id_pair 2> /dev/null
[ -f ~/.ssh/abagile-dev.pem ] && ssh-add ~/.ssh/abagile-dev.pem 2> /dev/null

export _git_log_fuller_format='%C(bold yellow)commit %H%C(auto)%d%n%C(bold)Author: %C(blue)%an <%ae> %C(reset)%C(cyan)%ai (%ar)%n%C(bold)Commit: %C(blue)%cn <%ce> %C(reset)%C(cyan)%ci (%cr)%C(reset)%n%+B'
export _git_log_oneline_format='%C(bold yellow)%h%C(reset) %s%C(auto)%d%C(reset)'
export _git_log_oneline_medium_format='%C(bold yellow)%h%C(reset) %<(50,trunc)%s %C(bold blue)<%an> %C(reset)%C(cyan)(%ar)%C(auto)%ad%C(reset)'

git-current-branch() {
  git symbolic-ref -q --short HEAD
}

git-branch-delete-interactive() {
  local -a remotes
  if (( ${*[(I)(-r|--remotes)]} )); then
    remotes=(${^*:#-*})
  else
    remotes=(${(f)"$(command git rev-parse --abbrev-ref ${^*:#-*}@{u} 2>/dev/null)"}) || remotes=()
  fi
  if command git branch --delete ${@} && \
      (( ${#remotes} )) && \
      read -q "?Also delete remote branch(es) ${remotes} [y/N]? "; then
    print
    local remote
    for remote (${remotes}) command git push ${remote%%/*} :${remote#*/}
  fi
}

# HSTR configuration - add this to ~/.zshrc
# alias hh=hstr                    # hh to be alias for hstr
# setopt histignorespace           # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor       # get more colors
bindkey -s "\C-r" "\C-a hstr -- \C-j"     # bind hstr to Ctrl-r (for Vi mode check doc)

# export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
