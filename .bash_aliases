alias :q="exit"
alias upds="$GITDIR/random/add_scripts.sh --yes"
alias clsl="find -L $HOME/bin -type l -print -exec rm {} +"

# clipboard
function clipboard_mac()  {
  alias c='pbcopy'
  alias cb='pbcopy'
  alias p='pbpaste'
  alias pb='pbpaste'
}

function clipboard_linux() {
  alias c='xclip'
  alias cb='xclip -sel clip'
  alias p='xclip -o'
  alias pb='xclip -o -sel clip'
}

alias ll="ls -lhF"
alias la="ls -alhF"
alias kssa='ps x | grep -v grep | grep ssh-agent | awk '"'"'{print $1}'"'"' | xargs -I{} kill {}'
alias gf='git grep --untracked -inrI . | fzf'
alias kgpg='pkill -9 gpg-agent'
alias sssha='. repoo'
alias rshift='redshift -PO 4000'
alias whatday="date | awk '{print \$1}'"
# no clobber
alias safecp='cp -n'
alias safemv='mv -n'
alias saferm='rm -i'

alias etmp='pushd $HOME/$(ls $HOME | grep tmpdir- | head -1)'
alias cltmp='rm -rf ~/tmpdir-*'
function tmp() {
  pushd $(temporary_work $@)
}

zipedit(){
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo "Usage: zipedit archive.zip folder/file.txt"
    return 1
  fi

  unzip "$1" "$2" -d /tmp
  curdir="$PWD"
  pushd /tmp
  vi "$2" && zip --update "$curdir/$1"  "$2"
  rm -f "$2"
  popd
}

alias sshg='ssh -A gurub'
alias sshe='ssh -A guru'
alias rtun='ssh -fNT -R 44442:localhost:22 api'

# arch
alias startxkde='echo exec startplasma-x11 > ~/.xinitrc && startx'
alias startxi3='echo exec i3 > ~/.xinitrc && startx'
alias startxawe='echo exec awesome > ~/.xinitrc && startx'

# python
function venv() {
  name=${1:-env}
  if [ ! -d "${name}" ]; then
    python3 -m venv "${name}"
  fi
  . "${name}/bin/activate"
  if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
  fi
}
alias dea='deactivate'

# docker
alias img='docker images'
alias cont='docker ps -a'
alias dels='docker service rm $(docker service ls -q &>/dev/null) 2>/dev/null'
alias deli='docker rmi -f $(docker images -q) 2>/dev/null'
alias delc='docker rm -f $(docker ps -aq) 2>/dev/null'
alias delv='docker volume rm $(docker volume ls -q) 2>/dev/null'
alias delb='yes | docker builder prune 2>/dev/null'
alias deln='docker network rm $(docker network ls -q) 2>/dev/null'
alias vls="docker volume ls"
alias alpine='docker run -ti alpine ash'
function deld() {
  delc; delv; dels; deln; deli; delb;
}

# navigation
alias pod='popd'
alias pud='pushd'
alias f='pushd'
alias ph='pushd ~'
alias bin='pushd ~/bin'
alias gh="pushd $GITDIR"
alias hg="$(which gh 2>/dev/null)"
alias dls='pushd ~/dls'
alias aur='mkdir -p ~/aur && pushd ~/aur'
alias goh='pushd $(go env GOPATH)/src/github.com'
alias dfs='pushd $GITDIR/dots'
alias scripts='pushd $GITDIR/random/thechosenones'
alias gr='pushd $(git rev-parse --show-toplevel)'

# clip daemon
alias cpd='clip_daemon'

# editing stuff
alias ecv='vim $(git diff --name-only --diff-filter=M)'
alias creb='git rebase --continue'
alias s='git status'
alias d='git diff'
alias sl='git slog'
alias l='git slog -10'

# vim
alias vi="vim"
alias vom="vim"
alias vm="vim"
alias im="vim"
alias bim="vim"
alias gim="vim"
alias vun="vim"
alias vbim="vim"
alias fvbim="vim"
alias fbim="vim"
alias bvim="vim"
alias tim="vim"
alias vdim="vim"
alias bvinm="vim"
alias vipm="vim"
alias vvim="vim"

if [[ "$OSTYPE" =~ "darwin" ]]; then
  clipboard_mac
else
  clipboard_linux
fi
