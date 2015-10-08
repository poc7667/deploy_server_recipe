# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export LC_ALL=C
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

plugins=(git ruby git-flow autojump git-prompt git git-flow ruby )

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source $HOME/git-flow-completion.zsh


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#pyenv virtualenvwrapper
source $HOME/.aliases

push_all() {
#  names=( "$@" )a
  names=( origin origin_1) # origin_2 )
  for i in $names
    do
        git push $i master
      done
  }

pull_all() {
    #  names=( "$@" )a
  names=( origin origin_1) # origin_2 )
  for i in $names
      do
              git pull $i master
              done
            }

f(){ find ./ -iname "*$1*" ;  }
cdp(){ cd "$(dirname "$1")" ; }