#! /usr/bin/env zsh

# update repository
git pull origin master
git submodule init
git submodule update

local repo=$(cd $(dirname $0); pwd)

() {
  local -a names
  local name

  # target filenames
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

  # check all filenames
  for name in $names; do
    [ -e $repo/$name ] || continue

    if [ -e $HOME/$name ]; then
      if [ -L $HOME/$name ] && [ $(readlink $HOME/$name) == $repo/$name ]; then
        echo $fg[green]"okay! symlink already exists: ~/$name -> $repo/$name"$fg[default]
      else
        echo $fg[red]"oops! unrelated file or directory already exists: ~/$name"$fg[default]
      fi
    else
      echo $fg[yellow]"create new symlink: ~/$name -> $repo/$name"$fg[default]
      ln -s $repo/$name $HOME/$name
    fi
  done
}

unset repo
