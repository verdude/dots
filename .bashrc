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
  if [[ -d /opt/homebrew ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew
  else
    export HOMEBREW_PREFIX=/usr/local
  fi

  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"

  case ":$PATH:" in
    *":$HOMEBREW_PREFIX/bin:"*) ;;
    *) export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH" ;;
  esac

  export MANPATH="$HOMEBREW_PREFIX/share/man:${MANPATH:-}"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

	_brew_real="$HOMEBREW_PREFIX/bin/brew"

	brew() {
		unset -f brew
		brewcompletionsh=$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh

		if [ -r "$brewcompletionsh" ]; then
			. "$brewcompletionsh"
		else
			echo "No completions Found."
		fi
		"$_brew_real" "$@"
	}
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
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
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

function nvm() {
  unset -f nvm
  local nvmdirs
  local dir

  nvmdirs=("$HOME/.nvm" "$HOMEBREW_PREFIX/opt/nvm")

  # breaks with name in home/homebrew path
  for dir in "${nvmdirs[@]}"; do
    if [ -s "$dir/nvm.sh" ]; then
      . "$dir/nvm.sh"
    fi
  done
  nvm
}

function pyenv() {
  unset -f pyenv
  export PYENV_ROOT="$HOME/.pyenv"

  if [[ -d $PYENV_ROOT ]]; then
    command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
  pyenv
}

function rbenv() {
  unset -f rbenv
  if which rbenv &> /dev/null; then
    eval "$(rbenv init -)"
  fi
  rbenv
}

function bun() {
  unset -f bun
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  bun
}

if [ -s "pyproject.toml" ] || [ -s "Pipfile" ]; then
  spyenv
fi

if [ -s "package.json" ]; then
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
