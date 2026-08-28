# author: Taehong Kim
# email: peppy0510@hotmail.com

ZSH_ACTIVATED_VIRTUAL_ENV=""

auto_activate_venv() {
    VIRTUALENV_NAMES=("venv" "env" ".venv" ".env")
    VIRTUALENV_BINDIRS=("bin" "Scripts")
    if [[ -n "$VIRTUAL_ENV" && -z "$ZSH_ACTIVATED_VIRTUAL_ENV" ]]; then
        for bindir in "${VIRTUALENV_BINDIRS[@]}"; do
            path=("${(@)path:#${VIRTUAL_ENV}/${bindir}}")
        done
        unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT _OLD_VIRTUAL_PATH _OLD_VIRTUAL_PYTHONHOME
    fi
    current="$PWD"
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
        current="${current:h}"
    done
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
        ZSH_ACTIVATED_VIRTUAL_ENV=""
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_activate_venv
