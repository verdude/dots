if [ -s /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -s /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

export GITDIR="${GITDIR:-$HOME/git}"
export PS1=" \W $ "

if [[ -s "$HOME/.alt" ]]; then
  source "$HOME/.alt"
fi

if [ -s "$HOME/.secrets.sh" ]; then
  . "$HOME/.secrets.sh"
fi

if [ -s "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

if [ -x /usr/bin/dircolors ] || [[ $OSTYPE == "darwin"* ]]; then
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

setxkbmap -option ctrl:nocaps &> /dev/null
export EDITOR=vim

export DOTDIR="$GITDIR/dots"
export GOPATH="$HOME/.go/go"
export PATH="$PATH:$GOPATH/bin:$HOME/bin:$HOME/.local/bin:$HOME/.bin" #:$HOME/.ebcli-virtual-env/bin/"
export PATH="$PATH:/opt/homebrew/opt/qt@5/bin"
export LS_COLORS='ow=01;36;40'
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE="$HOME/.bash_eternal_history"
export HISTCONTROL="ignorespace:erasedups"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## VIm
mkdir -p /tmp/.backup
mkdir -p /tmp/.undo

# NVM LMAO! SUPER SLOW!
function snvm() {
  nvmdirs=("$HOME/.nvm" "$HOMEBREW_PREFIX/opt/nvm")
  # breaks with name in home/homebrew path
  for dir in ${nvmdirs[@]}; do
    if [ -s "$dir/nvm.sh" ]; then
      . "$dir/nvm.sh"
    fi
  done
}

function spyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  if [[ -d $PYENV_ROOT ]]; then
    command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
}

function srbenv() {
  which rbenv &> /dev/null && eval "$(rbenv init -)"
}

function sbrew() {
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function smojo() {
  mhome="${HOME}/.modular"
  if [ -d "$mhome" ]; then
    export MODULAR_HOME=$mhome
    export PATH="${PATH}:${mhome}/pkg/packages.modular.com_mojo/bin"
  fi
}

if [[ $OSTYPE == "darwin"* ]]; then
  sbrew
fi

if [ -s "pyproject.toml" ] || [ -s "Pipfile" ]; then
  spyenv

elif [ -s "Gemfile" ]; then
  srbenv

elif [ -s "package.json" ]; then
  snvm
fi

cargobin=$HOME/.cargo/bin/
if [ -d "$cargobin" ]; then
  export PATH="$PATH:${cargobin}"
fi

brootlauncherpath=$HOME/.config/broot/launcher/bash/br
if [ -s "$brootlauncherpath" ]; then
  . "$brootlauncherpath"
fi

fzfbindings=/usr/share/fzf/key-bindings.bash
fzfubindings=/usr/share/doc/fzf/examples/key-bindings.bash
fzfmacbindings="/opt/homebrew/Cellar/fzf/0.46.1/shell/key-bindings.bash"
if [ -s "$fzfbindings" ]; then
  . "$fzfbindings"
elif [ -s "$fzfubindings" ]; then
  . "$fzfubindings"
elif [ -s "$fzfmacbindings" ]; then
  . "$fzfmacbindings"
fi
