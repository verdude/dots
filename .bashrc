if [ -s /etc/bashrc ]; then
  . /etc/bashrc
elif [ -s /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

set -o vi
bind -m vi-insert '"\C-l": clear-screen'
bind -m vi-command '"\C-l": clear-screen'
export GITDIR="${GITDIR:-$HOME/git}"
export PS1=" ${HOSTNAME:0:2} \W $ "
export AUR="${HOME}/.cache/aur"

declare -i __darwin=0
if [[ $OSTYPE == darwin* ]]; then
  __darwin=1
fi

if ((__darwin)); then
  function sbrew() {
    local brew_bin
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      brew_bin="/opt/homebrew/bin/brew"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      brew_bin="/usr/local/bin/brew"
    else
      echo "Warning: brew command not found in /opt/homebrew/bin or /usr/local/bin" >&2
      return 1
    fi
    eval "$($brew_bin shellenv)"
    psqlpath=(/opt/homebrew/opt/postgresql@*/bin/)
    if [ "${#psqlpath[@]}" -gt 0 ]; then
      export PATH="$PATH:${psqlpath[0]}"
    fi
  }
  sbrew
  prefix=$(brew --prefix)
  brewcompletionsh=$prefix/etc/profile.d/bash_completion.sh

  if [ -r "$brewcompletionsh" ]; then
    . "$brewcompletionsh"
  fi
fi

if [[ -s "$HOME/.alt" ]]; then
  source "$HOME/.alt"
fi

if [ -s "$HOME/.secrets.sh" ]; then
  . "$HOME/.secrets.sh"
fi

if [ -s "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

if [ -x /usr/bin/dircolors ] || ((__darwin)); then
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

setxkbmap -option ctrl:nocaps &> /dev/null
export EDITOR=vim

export DOTDIR="$GITDIR/dots"
export GOPATH="$HOME/.go/go"
export PATH="$PATH:$GOPATH/bin:$HOME/bin:$HOME/.local/bin:$HOME/.bin"
if ((__darwin)); then
  export PATH="$PATH:$prefix/opt/qt@5/bin"
fi
export PATH="$PATH:$HOME/fvm/default/bin"
export LS_COLORS='ow=01;36;40'

if ! ((__darwin)); then
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
elif [[ -n "$(ps x | grep ssh-agent | grep -vE 'grep|defunct')" ]]; then
  eval $(keychain --agents ssh --eval id_ed25519 2> /dev/null)
fi

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

function smojo() {
  mhome="${HOME}/.modular"
  if [ -d "$mhome" ]; then
    export MODULAR_HOME=$mhome
    export PATH="${PATH}:${mhome}/pkg/packages.modular.com_mojo/bin"
  fi
}

function seb() {
  if [ -n "$VIRTUAL_ENV" ]; then
    dea
    echo "去除eb了"
  fi
  ph
  venv
  pod
  echo "新增eb了"
}

if [ -s "pyproject.toml" ] || [ -s "Pipfile" ]; then
  spyenv

elif [ -s "Gemfile" ]; then
  srbenv
fi

cargobin=$HOME/.cargo/bin/
if [ -d "$cargobin" ]; then
  export PATH="$PATH:${cargobin}"
fi

brootlauncherpath=$HOME/.config/broot/launcher/bash/br
if [ -s "$brootlauncherpath" ]; then
  . "$brootlauncherpath"
fi

fzfbindings=(
  /usr/share/fzf/key-bindings.bash
  /usr/share/doc/fzf/examples/key-bindings.bash
  /opt/homebrew/Cellar/fzf/**/shell/key-bindings.bash
)

for b in "${fzfbindings[@]}"; do
  if [[ -f "$b" ]]; then
    . "$b"
    break
  fi
done

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
