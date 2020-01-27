if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  yes n | ~/.fzf/install
fi

cd ~/.dotfiles/stow
for s in *; do stow -t ~ $s; done

mkdir -p ~/.psql_history

vi +PlugInstall +qall
