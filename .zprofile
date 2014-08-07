# exports
# =======

# make unique
typeset -U path PATH
typeset -U cdpath CDPATH
typeset -U fpath FPATH
typeset -U manpath MANPATH

# lang
export LANG=ja_JP.UTF-8

# homebrew
path=(
  /usr/local/bin(N-/)
  ${path}
)

# editor
export EDITOR=vim

# golang
if [ -x "`which go`" ]; then
  typeset -xTU GOROOT goroot
  typeset -xTU GOPATH gopath
  goroot=`go env GOROOT`
  gopath=(${HOME}/go(N-/))
  path=(
    ${path}
    ${GOROOT}/bin(N-/)
    ${GOPATH}/bin(N-/)
  )
fi

# nvm
# ===

[ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh"

# rvm
# ===

[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"

# local zprofile
# ==============

if [ -r "$HOME/.zprofile.local.zsh" ] && [ -f "$HOME/.zprofile.local.zsh" ]; then
  source "$HOME/.zprofile.local.zsh"
fi
