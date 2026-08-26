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
  __brew=
  for __brew_candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x $__brew_candidate ]]; then
      __brew=$__brew_candidate
      break
    fi
  done

  if [[ -n $__brew ]]; then
    # Homebrew's shellenv moves its bin/sbin ahead of the system paths so
    # `bash` resolves to Homebrew's bash when it is installed.
    eval "$("$__brew" shellenv)"

    _brew_real="$__brew"

    brew() {
      unset -f brew
      local brewcompletionsh="$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

      if [ -r "$brewcompletionsh" ]; then
        . "$brewcompletionsh"
      else
        echo "No completions Found."
      fi
      "$_brew_real" "$@"
    }
  fi

  unset __brew __brew_candidate
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
else
  # ssh-agent linux setup
  if [[ -z ${SSH_CONNECTION:-} || -z ${SSH_AUTH_SOCK:-} ]]; then
    if [[ -r $HOME/.keychain/$HOSTNAME-sh ]]; then
      . "$HOME/.keychain/$HOSTNAME-sh"
    fi
  fi

  if [[ -z ${SSH_AUTH_SOCK:-} ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/gcr/ssh"
  fi
fi
export PATH="$PATH:$HOME/fvm/default/bin"
export LS_COLORS='ow=01;36;40'

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE="$HOME/.bash_eternal_history"
export HISTCONTROL="ignorespace:erasedups"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## VIm
mkdir -p /tmp/.backup /tmp/.undo

function spyenv() {
  export PYENV_ROOT="$HOME/.pyenv"

  if [[ -d $PYENV_ROOT ]]; then
    command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
}

function srbenv() {
  if which rbenv &> /dev/null; then
    eval "$(rbenv init -)"
  fi
}

function sbun() {
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
}

if [ -s "pyproject.toml" ] || [ -s "Pipfile" ]; then
  spyenv
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

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
