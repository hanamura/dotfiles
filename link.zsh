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
  __link $repo/.vim                    $HOME/.vim
  __link $repo/.snippets               $HOME/.snippets
  __link $repo/.vimrc                  $HOME/.vimrc
  __link $repo/.vimrc.basic            $HOME/.vimrc.basic
  __link $repo/.vimrc.bundle           $HOME/.vimrc.bundle
  __link $repo/.vimrc.mapping          $HOME/.vimrc.mapping
  __link $repo/.vimrc.plugins_settings $HOME/.vimrc.plugins_settings

  # zsh
  __link $repo/.oh-my-zsh $HOME/.oh-my-zsh
  __link $repo/.zshrc     $HOME/.zshrc
  __link $repo/.zprofile  $HOME/.zprofile
  __link $repo/.zlogin    $HOME/.zlogin

  # atom
  __link $repo/.atom $HOME/.atom

  # karabiner
  __link $repo/private.xml "$HOME/Library/Application Support/Karabiner/private.xml"

  # tig
  __link $repo/.tigrc $HOME/.tigrc

  # peco
  __link $repo/.peco $HOME/.peco

  # qmk

  # $ make planck/rev4:hanamura:dfu
  rm -rf $repo/qmk_firmware/keyboards/planck/keymaps/hanamura
  cp -r $repo/keyboards/planck/hanamura $repo/qmk_firmware/keyboards/planck/keymaps/hanamura

  # $ make lets_split/rev2:hanamura:avrdude
  rm -rf $repo/qmk_firmware/keyboards/lets_split/keymaps/hanamura
  cp -r $repo/keyboards/lets_split/hanamura $repo/qmk_firmware/keyboards/lets_split/keymaps/hanamura

  echo "⌨️  Copy keymaps"
}

unset repo
