if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export GITDIR="${GITDIR:-$HOME/git}"

if [ -f $HOME/.secrets.sh ]; then
    . $HOME/.secrets.sh
fi

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

set -o vi
setxkbmap -option ctrl:nocaps 2>/dev/null

export EDITOR=vim

export DOTDIR=$GITDIR/dots
export PATH="$PATH:$HOME/.go/go/bin:$HOME/bin:$HOME/.local/bin:$HOME/.bin"
export GOPATH="$HOME/.go/go"
export LS_COLORS='ow=01;36;40'

[[ -n "$(ps x | grep ssh-agent | grep -vE 'grep|defunct')" ]] && eval $(keychain --agents ssh --eval id_ed25519 2>/dev/null)

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=$HOME/.bash_eternal_history
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## VIm
mkdir -p /tmp/.backup
mkdir -p /tmp/.undo

# NVM LMAO! SUPER SLOW!
function snvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

function spyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  if [[ -d "$PYENV_ROOT" ]]; then
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
}

function scargo() {
  local cargoenv="$HOME/.cargo/env"
  if [[ -f $cargoenv ]]; then
    . $cargoenv
    export PATH="$HOME/.cargo/bin:$PATH"
  fi
}

function srbenv() {
  which rbenv &>/dev/null && eval "$(rbenv init -)"
}

if [ -f "pyproject.toml" ] || [ -f "Pipfile" ]; then
  spyenv

elif [ -f "Cargo.toml" ]; then
  scargo

elif [ -f "Gemfile" ]; then
  srbenv

elif [ -f "package.json" ]; then
  snvm
fi

brootlauncher=/home/erra/.config/broot/launcher/bash/br
if [ -f $brootlauncher ]; then
  . $brootlauncher
fi
