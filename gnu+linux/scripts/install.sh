#!/bin/bash

DOTFILES_PATH="${HOME}/Development/github/aharris88/settings/gnu+linux"

function green_echo {
  GREEN='\033[0;32m'
  NC='\033[0m'
  echo -e "${GREEN}$1${NC}"
}

function red_echo {
  RED='\033[0;31m'
  NC='\033[0m'
  echo -e "${RED}$1${NC}"
}

function install_zsh () {
  green_echo 'Installing zsh'
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
      sudo apt-get install zsh
      install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
      echo "Please install zsh, then re-run this script!"
      exit
    fi
  fi
}

function uninstall_packages {
  apps='unity-webapps-common'

  for app in $apps; do
    which $app > /dev/null
    if [ $? == 0 ]; then
      green_echo "Uninstalling ${app}"
      sudo apt-get --assume-yes purge $app
    fi
  done
}

function install_npm {
  mkdir "${HOME}/.npm-packages"
  mkdir "${HOME}/.node_versions"

  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo apt-get install -y npm
}

function install_npm_packages {
  green_echo 'Installing npm packages'
  apps=$(cat "${DOTFILES_PATH}/apps/npm.txt")

  for app in $apps; do
    which $app > /dev/null
    if [ $? == 1 ]; then
      green_echo "Installing ${app}"
      npm install -g $app
    fi
  done
}

function install_packages {
  green_echo 'Installing packages'
  apps=$(cat "${DOTFILES_PATH}/apps/packages.txt")

  for app in $apps; do
    which $app > /dev/null
    if [ $? == 1 ]; then
      green_echo "Installing ${app}"
      sudo apt-get install --assume-yes $app
    fi
  done
}

function copy_dotfiles {
  green_echo 'Copying dotfiles'

  mkdir -p ~/.OLD_DOTFILES

  for file in $(find "${DOTFILES_PATH}/dotfiles" -maxdepth 1 -mindepth 1 -exec basename {} \;); do
    if [ -e ~/$file ]; then
      mv ~/$file ~/.OLD_DOTFILES/$file
    fi
    if [ ! -e ~/$file ]; then
      ln -s "${DOTFILES_PATH}/dotfiles/$file" "${HOME}/${file}"
    fi
  done
}

function ruby {
  if ! command -v rbenv >/dev/null; then
    if ! command -v rvm >/dev/null; then
      green_echo 'Installing RVM and the latest Ruby...'
      sudo apt-add-repository -y ppa:rael-gc/rvm
      sudo apt-get update
      sudo apt-get install --assume-yes rvm
      rvm install ruby
    else
      local_version="$(rvm -v 2> /dev/null | awk '$2 != ""{print $2}')"
      latest_version="$(curl -s https://raw.githubusercontent.com/wayneeseguin/rvm/stable/VERSION)"
      if [ "$local_version" != "$latest_version" ]; then
        green_echo 'Upgrading RVM...'
        rvm get stable --auto-dotfiles --autolibs=enable --with-gems="bundler"
      else
        green_echo "Already using the latest version of RVM. Skipping..."
      fi
    fi
  fi
}

function install_or_update_gem {
  if gem list "$1" | grep "^$1 ("; then
    green_echo "Updating $1..."
    gem update "$@"
  else
    green_echo "Installing $1..."
    gem install "$@"
  fi
}

function ruby_gems {
  gems=$(cat "${DOTFILES_PATH}/apps/ruby_gems.txt")

  green_echo 'Installing Ruby gems'
  for gem in $gems; do
    install_or_update_gem $gem
  done
}

function install {
  uninstall_packages
  install_zsh 
  copy_dotfiles
  install_packages
  install_npm
  install_npm_packages
  ruby
  ruby_gems
}

install
