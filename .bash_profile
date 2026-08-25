declare -i __ssh_agent_forwarded=0
if [[ -n ${SSH_CONNECTION:-} && -n ${SSH_AUTH_SOCK:-} ]]; then
    __ssh_agent_forwarded=1
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# GCR can enumerate locked keys in a headless session but cannot sign without
# a graphical unlock prompt.  Start/reuse keychain once per login shell and
# then import its cached environment without command substitution.  Preserve
# an agent forwarded into an SSH login.
if ((!__darwin && !__ssh_agent_forwarded)); then
    keychain --quiet --no-gui --no-inherit add "$HOME/.ssh/id_ed25519"
    if [[ -r $HOME/.keychain/$HOSTNAME-sh ]]; then
        . "$HOME/.keychain/$HOSTNAME-sh"
    fi
fi
unset __ssh_agent_forwarded
