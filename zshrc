# Path to oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="mh"
DEFAULT_USER=aharris88

# Aliases
alias ll='ls -la'
alias ..='cd ..'
alias ~='cd ~'
alias gitgraph='git log --graph --oneline --decorate --all'
alias adb='adb forward tcp:9222 localabstract:chrome_devtools_remote'
alias geeknote='python ~/geeknote/geeknote.py'
alias ttytter='perl ~/ttytter/ttytter.pl'
alias bower='noglob bower' #Only needed for prezto or oh-my-zsh
# Commands for pianobar
alias p='~/.config/pianobar/fifoCommands.sh' 

# Turn on 255 Color
set -g default-terminal "screen-256color"

# Disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# RVM
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

# Path
PATH="/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
#path to node
PATH="$PATH:/usr/local/lib/node_modules"
#path to gem installed libraries
PATH="$PATH:/usr/local/opt/ruby/bin"
PATH="$PATH:/Library/Ruby/Gems/2.0.0/gems"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#Android SDK
PATH="$PATH:/Users/aharris88/adt/sdk/platform-tools:/Users/aharris88/adt/sdk/tools"

export PATH

export LC_ALL=$LANG
