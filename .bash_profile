declare -i __ssh_agent_forwarded=0
if [[ -n ${SSH_CONNECTION:-} && -n ${SSH_AUTH_SOCK:-} ]]; then
    __ssh_agent_forwarded=1
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

__start_keychain() {
    local -a keychain_args
    keychain_args=(--quiet --nogui --noinherit)
    command keychain "${keychain_args[@]}"
}

if ((!__darwin && !__ssh_agent_forwarded)); then
    __start_keychain
    if [[ -r $HOME/.keychain/$HOSTNAME-sh ]]; then
        . "$HOME/.keychain/$HOSTNAME-sh"
    fi
fi
unset -f __start_keychain
unset __ssh_agent_forwarded
