#!/usr/local/bin/zsh

# update repository
git pull origin master
git submodule init
git submodule update

local repo=$(cd $(dirname $0); pwd)

__link() {
  local src=$1
  local dst=$2
  local dir="$(dirname $dst)"

  # check source
  if [ ! -e $src ]; then
    echo $fg[red]"oops! not found in this repository: $src"$fg[default]
    return
  fi

  # check destination
  if [ -e $dst ]; then
    if [ -L $dst ] && [ "$(readlink $dst)" '==' $src ]; then
      echo $fg[green]"okay! symlink already exists:\n  - from: $dst\n  - to:   $src"$fg[default]
      return
    else
      echo $fg[red]"? oops! unrelated file or directory already exists: $dst"$fg[default]
      return
    fi
  fi

  # check destination directory
  if [ -e $dir ] && [ ! -d $dir ]; then
    echo $fg[red]"x oops! unrelated file or directory already exists: $dst"$fg[default]
    return
  fi

  # create directories
  if [ ! -d $dir ]; then
    mkdir -p $dir
  fi

  # create link
  echo $fg[yellow]"create new symlink:\n  - from: $dst\n  - to:   $src"$fg[default]
  ln -s $src $dst
}

() {
  local -a names
  local name
  local filepath

  # targets
  names=(
    # ruby
    ".gemrc"
    # git
    ".gitattributes"
    ".gitconfig"
    ".gitignore_global"
    # vim
    ".vim"
    ".snippets"
    ".gvimrc"
    ".vimrc"
    ".vimrc.basic"
    ".vimrc.bundle"
    ".vimrc.mapping"
    ".vimrc.plugins_settings"
    # zsh
    ".oh-my-zsh"
    ".zshrc"
    ".zprofile"
    ".zlogin"
    # atom
    ".atom"
  )
  for name in $names; do
    __link $repo/$name $HOME/$name
  done
}

unset repo
