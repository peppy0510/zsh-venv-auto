# author: Taehong Kim
# email: peppy0510@hotmail.com

ZSH_ACTIVATED_VIRTUAL_ENV=""

auto_activate_venv() {
    local -a names=("venv" "env" ".venv" ".env") bindirs=("bin" "Scripts")
    local current name bindir activate
    if [[ -n "$VIRTUAL_ENV" && -z "$ZSH_ACTIVATED_VIRTUAL_ENV" ]]; then
        if (( $+functions[deactivate] )); then
            # activated by hand in this shell: its deactivate puts the prompt back too
            deactivate
        else
            # inherited from a parent shell, which kept the deactivate
            for bindir in "${bindirs[@]}"; do
                path=("${(@)path:#${VIRTUAL_ENV}/${bindir}}")
            done
            unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT _OLD_VIRTUAL_PATH _OLD_VIRTUAL_PYTHONHOME
        fi
    fi
    current="$PWD"
    while [[ "$current" != "/" ]]; do
        for name in "${names[@]}"; do
            for bindir in "${bindirs[@]}"; do
                activate="$current/$name/$bindir/activate"
                if [[ -f "$activate" ]]; then
                    # by the script found, as VIRTUAL_ENV keeps the path the venv was made at
                    if [[ "$ZSH_ACTIVATED_VIRTUAL_ENV" != "$activate" || -z "$VIRTUAL_ENV" ]]; then
                        [[ -n "$VIRTUAL_ENV" ]] && (( $+functions[deactivate] )) && deactivate
                        source "$activate"
                        ZSH_ACTIVATED_VIRTUAL_ENV="$activate"
                    fi
                    return
                fi
            done
        done
        current="${current:h}"
    done
    if [[ -n "$ZSH_ACTIVATED_VIRTUAL_ENV" ]]; then
        [[ -n "$VIRTUAL_ENV" ]] && (( $+functions[deactivate] )) && deactivate
        ZSH_ACTIVATED_VIRTUAL_ENV=""
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_activate_venv
