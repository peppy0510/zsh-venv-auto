# author: Taehong Kim
# email: peppy0510@hotmail.com

ZSH_ACTIVATED_VIRTUAL_ENV=""

auto_activate_venv() {
    VIRTUALENV_NAMES=("venv" "env" ".venv" ".env")
    VIRTUALENV_BINDIRS=("bin" "Scripts")
    current="$PWD"
    if [[ -n "$VIRTUAL_ENV" && -z "$ZSH_ACTIVATED_VIRTUAL_ENV" ]]; then
        for bindir in "${VIRTUALENV_BINDIRS[@]}"; do
            if [[ -f "$current/$name/${bindir}/activate" ]]; then
                source "$VIRTUAL_ENV/bin/activate" && deactivate
            fi
        done
    fi
    while [[ "$current" != "/" ]]; do
        for name in "${VIRTUALENV_NAMES[@]}"; do
            for bindir in "${VIRTUALENV_BINDIRS[@]}"; do
                if [[ -d "$current/$name" && -f "$current/$name/${bindir}/activate" ]]; then
                    if [[ "$VIRTUAL_ENV" != "$current/$name" ]]; then
                        [[ -n "$VIRTUAL_ENV" ]] && deactivate
                        source "$current/$name/${bindir}/activate"
                        ZSH_ACTIVATED_VIRTUAL_ENV="$current/$name/${bindir}/activate"
                    fi
                    return
                fi
            done
        done
        current="$(dirname "$current")"
    done
    [[ -n "$VIRTUAL_ENV" ]] && deactivate
    export PATH=${HOME}/.local/bin${PATH:+:${PATH}}
}

cd() {
    builtin cd "$@" && auto_activate_venv
}

pushd() {
    builtin pushd "$@" && auto_activate_venv
}

popd() {
    builtin popd "$@" && auto_activate_venv
}

auto_activate_venv
