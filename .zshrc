# oh-my-zsh settings
# ==================

export ZSH=$HOME/.oh-my-zsh

# MacVim’s :sh
if [ $TERM = 'dumb' ]; then
  ZSH_THEME="evan"
else
  ZSH_THEME="robbyrussell"
fi

plugins=(
  brew
  bundler
  composer
  gem
  git
  github
  go
  gulp
  heroku
  npm
  nvm
  osx
  ruby
  vagrant
  wp-cli
)

source $ZSH/oh-my-zsh.sh

# zsh cdr command
# ===============

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# exports
# =======

# make unique

typeset -U path PATH
typeset -U cdpath CDPATH
typeset -U fpath FPATH
typeset -U manpath MANPATH

export LANG=ja_JP.UTF-8
export EDITOR=vim

# homebrew

path=(
  /usr/local/bin(N-/)
  ${path}
)

# aliases & functions
# ===================

# daily temporary directory

function todaytmp() {
  local name=`date +"$HOME/temporary/%Y-%m-%d"`
  mkdir -p $name
  cd $name
}

# ip

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# serve

alias serve="python -m SimpleHTTPServer"

# peco - repositories

alias peg='cd $(ghq list -p | peco)'

# peco - ssh hosts

alias pes='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | peco | awk "{print \$2}") 2>/dev/null'

# peco - cdr

function pec() {
  local dir=$(cdr -l | awk '{ print $2 }' | peco | sed "s;~;$HOME;")
  if [ -d $dir ]; then
    cd $dir
  else
    echo 'Not exist'
  fi
}

# peco - kill

alias pek='ps aux | tail -n +2 | peco | awk '"'"'{ print $2 }'"'"' | xargs kill'

# hub

if type hub >/dev/null 2>&1; then
  alias git=hub
  compdef hub=git
fi

# html_escape
# html-minifier is npm module

alias html_escape="html-minifier | php -r \"echo htmlspecialchars(stream_get_contents(STDIN));\""

# nvm
# ===

export NVM_DIR="/Users/hanamura/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# rbenv
# =====

export RBENV_ROOT=/usr/local/var/rbenv

if type rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# golang
# ======

if type go >/dev/null 2>&1; then
  typeset -xTU GOROOT goroot
  typeset -xTU GOPATH gopath
  goroot=`go env GOROOT`
  gopath=$HOME/.go
  path=(
    ${path}
    ${GOROOT}/bin(N-/)
    ${GOPATH}/bin(N-/)
  )
fi

# local zshrc
# ===========

if [ -r "$HOME/.zshrc.local.zsh" ] && [ -f "$HOME/.zshrc.local.zsh" ]; then
  source "$HOME/.zshrc.local.zsh"
fi

# node completions (after `nvm use ...`)
# ======================================

# gulp

if type gulp >/dev/null 2>&1; then
  eval "$(gulp --completion=zsh)"
fi

# Let <C-s> work in terminal vim
# https://github.com/kien/ctrlp.vim/issues/359
# https://stackoverflow.com/questions/8616843/ctrl-s-is-not-working-as-a-horizontal-split-in-vim-when-using-commandt
# ==============================

stty -ixon -ixoff
