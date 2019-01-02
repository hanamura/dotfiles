#!/usr/local/bin/zsh

local repo=$(cd $(dirname $0); pwd)

__link() {
  local src=$1
  local dst=$2
  local dst_dir="$(dirname $dst)"

  local r=$(tput setaf 1)
  local g=$(tput setaf 2)
  local c=$(tput setaf 6)
  local x=$(tput sgr0)

  # check source
  if [ ! -e $src ]; then
    echo "👀${r}  Source not found${x}\n   ➜ ${src}"
    return
  fi

  # check destination
  if [ -e $dst ] && [ -L $dst ] && [ "$(readlink $dst)" '==' $src ]; then
    echo "👍🏼${g}  Correct symlink already exists${x}\n   ➜ from: ${dst}\n   ➜ to:   ${src}"
    return
  fi

  # check destination
  if [ -e $dst ]; then
    echo "🤔${r}  Unrelated file/directory already exists${x}\n   ➜ ${dst}"
    return
  fi

  # check destination directory
  if [ -e $dst_dir ] && [ ! -d $dst_dir ]; then
    echo "🚷${r}  Unreachable to destination${x}\n   ➜ ${dst}"
    return
  fi

  # create directories
  if [ ! -d $dst_dir ]; then
    echo "⚒${c}  Create new directory${x}\n   ➜ ${dst_dir}"
    mkdir -p $dst_dir
  fi

  # create link
  echo "⚒${c}  Create new symlink${x}\n   ➜ from: ${dst}\n   ➜ to:   ${src}"
  ln -s $src $dst
}

() {
  # editorconfig
  __link $repo/.editorconfig $HOME/.editorconfig

  # javascript
  __link $repo/.eslintrc $HOME/.eslintrc

  # ruby
  __link $repo/.gemrc $HOME/.gemrc

  # git
  __link $repo/.gitattributes    $HOME/.gitattributes
  __link $repo/.gitconfig        $HOME/.gitconfig
  __link $repo/.gitignore_global $HOME/.gitignore_global

  # vim
  __link $repo/.config $HOME/.config
  __link $repo/.local $HOME/.local
  __link $repo/.snippets $HOME/.snippets

  # vscode
  __link $repo/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
  __link $repo/vscode/settings.json    $HOME/Library/Application\ Support/Code/User/settings.json

  # zsh
  __link $repo/.oh-my-zsh $HOME/.oh-my-zsh
  __link $repo/.zshrc     $HOME/.zshrc
  __link $repo/.zprofile  $HOME/.zprofile
  __link $repo/.zlogin    $HOME/.zlogin

  # tig
  __link $repo/.tigrc $HOME/.tigrc

  # peco
  __link $repo/.peco $HOME/.peco

  # hammerspoon
  __link $repo/.hammerspoon $HOME/.hammerspoon
}

unset repo
