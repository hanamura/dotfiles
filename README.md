# hanamura/dotfiles

**Please do NOT use this dotfiles directly.** These settings are optimized just for [me](https://github.com/hanamura).

## Environment

- OS: macOS
- Package Manager: Homebrew
- Shell: zsh with oh-my-zsh
- Editor: Vim and Neovim

## Usage

### Setup

```sh
$ git clone --recursive git@github.com:hanamura/dotfiles.git
$ cd dotfiles
$ ./link.zsh
```

### Update

```sh
$ git pull origin master
$ git submodule init
$ git submodule update
$ ./link.zsh
```

## References

- https://github.com/mathiasbynens/dotfiles
- https://github.com/yuroyoro/dotfiles
