# oh-my-zsh settings
# ==================

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(
  bower
  brew
  bundler
  composer
  emoji-clock
  gem
  git
  go
  heroku
  npm
  osx
  ruby
  vagrant
)

source $ZSH/oh-my-zsh.sh

# zsh cdr command
# ===============

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# User configuration
# ==================

# local zshrc
if [ -r "$HOME/.zshrc.local.zsh" ] && [ -f "$HOME/.zshrc.local.zsh" ]; then
  source "$HOME/.zshrc.local.zsh"
fi

# alias
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# utilities
function todaytmp() {
  local name=`date +"$HOME/temporary/%Y-%m-%d"`

  [ -e $name ] || mkdir -p $name

  if [[ $1 = 'open' ]]; then
    open $name
  else
    cd $name
  fi
}

# peco
# ====

# repositories
alias peg='cd $(ghq list -p | peco)'

# ssh hosts
alias pes='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | peco | awk "{print \$2}") 2>/dev/null'

# vagrant directories
alias pev='cd $(ls -1 ~/vagrant | peco | awk "{ print ENVIRON[\"HOME\"] \"/vagrant/\" \$1 }")'

# cdr + peco
function pec() {
  local dir=$(cdr -l | awk '{ print $2 }' | peco | sed "s;~;$HOME;")
  if [ -d $dir ]; then
    cd $dir
  else
    echo 'Not exist'
  fi
}

# npm completion
# ==============

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
