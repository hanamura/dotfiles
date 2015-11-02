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
  bower
  brew
  bundler
  composer
  gem
  git
  go
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

  [ -e $name ] || mkdir -p $name

  if [[ $1 = 'open' ]]; then
    open $name
  else
    cd $name
  fi
}

# ip

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# serve

alias serve="python -m SimpleHTTPServer"

# peco - repositories

alias peg='cd $(ghq list -p | peco)'

# peco - ssh hosts

alias pes='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | peco | awk "{print \$2}") 2>/dev/null'

# peco - vagrant directories

alias pev='cd $(ls -1 ~/vagrant | peco | awk "{ print ENVIRON[\"HOME\"] \"/vagrant/\" \$1 }")'

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

# grunt

if type grunt >/dev/null 2>&1; then
  eval "$(grunt --completion=zsh)"
fi

# gulp

if type gulp >/dev/null 2>&1; then
  eval "$(gulp --completion=zsh)"
fi

# keypad
# ======

# http://superuser.com/questions/742171/zsh-z-shell-numpad-numlock-doesnt-work

# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"
