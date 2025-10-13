# author: Taehong Kim
# email: peppy0510@hotmail.com

ZSH_ACTIVATED_VIRTUAL_ENV=""

auto_activate_venv() {
    VIRTUALENV_NAMES=("venv" "env" ".venv" ".env")
    current="$PWD"
    if [[ -n "$VIRTUAL_ENV" && -z "$ZSH_ACTIVATED_VIRTUAL_ENV" ]]; then
        source "$VIRTUAL_ENV/bin/activate" && deactivate
    fi
    while [[ "$current" != "/" ]]; do
        for name in "${VIRTUALENV_NAMES[@]}"; do
            if [[ -d "$current/$name" && -f "$current/$name/bin/activate" ]]; then
                if [[ "$VIRTUAL_ENV" != "$current/$name" ]]; then
                    [[ -n "$VIRTUAL_ENV" ]] && deactivate
                    source "$current/$name/bin/activate"
                    ZSH_ACTIVATED_VIRTUAL_ENV="$current/$name/bin/activate"
                fi
                return
            fi
        done
        current="$(dirname "$current")"
    done
    [[ -n "$VIRTUAL_ENV" ]] && deactivate
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
