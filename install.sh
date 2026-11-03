#!/bin/sh
# author: Taehong Kim
# email: peppy0510@hotmail.com
#
# curl -fsSL https://raw.githubusercontent.com/peppy0510/zsh-venv-auto/main/install.sh | sh
#
# Puts the plugin in the oh-my-zsh custom folder when there is one, ~/.zsh-venv-auto otherwise,
# and appends a block to the end of ~/.zshrc: the first activation has to come after every PATH
# export, as deactivate restores the PATH it saw. Running it again updates the plugin and moves
# the block back to the end.

set -eu

NAME='zsh-venv-auto'
REPOSITORY="https://github.com/peppy0510/$NAME"
BRANCH="${ZSH_VENV_AUTO_BRANCH:-main}"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
BEGIN="# >>> $NAME >>>"
END="# <<< $NAME <<<"

fail() {
    printf '%s: %s\n' "$NAME" "$*" >&2
    exit 1
}

download() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$1" -o "$2"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$1" -O "$2"
    else
        fail 'needs git, curl or wget to download the plugin.'
    fi
}

command -v zsh >/dev/null 2>&1 || fail 'zsh is not installed.'

if [ -n "${ZSH_CUSTOM:-}" ]; then
    target="$ZSH_CUSTOM/plugins/$NAME"
elif [ -d "${ZSH:-$HOME/.oh-my-zsh}/custom" ]; then
    target="${ZSH:-$HOME/.oh-my-zsh}/custom/plugins/$NAME"
else
    target="$HOME/.$NAME"
fi

if [ -d "$target/.git" ] && command -v git >/dev/null 2>&1; then
    git -C "$target" pull --quiet --ff-only
elif [ ! -e "$target" ] && command -v git >/dev/null 2>&1; then
    mkdir -p "$(dirname "$target")"
    git clone --quiet --depth 1 --branch "$BRANCH" "$REPOSITORY.git" "$target"
else
    mkdir -p "$target"
    download "https://raw.githubusercontent.com/peppy0510/$NAME/$BRANCH/$NAME.plugin.zsh" \
        "$target/$NAME.plugin.zsh.download"
    mv "$target/$NAME.plugin.zsh.download" "$target/$NAME.plugin.zsh"
fi

# written with $HOME so a .zshrc shared between machines keeps working
case "$target" in
    "$HOME"/*) source_path="\$HOME${target#"$HOME"}/$NAME.plugin.zsh" ;;
    *) source_path="$target/$NAME.plugin.zsh" ;;
esac

if [ -f "$ZSHRC" ]; then
    backup="$ZSHRC.bak-$NAME-$(date +%Y%m%d%H%M%S)"
    cp -p "$ZSHRC" "$backup"
    # an earlier block goes, so the new one lands below whatever was added since
    awk -v begin="$BEGIN" -v end="$END" '
        $0 == begin { skip = 1; next }
        $0 == end { skip = 0; next }
        !skip
    ' "$backup" > "$ZSHRC.$NAME.tmp"
else
    backup=''
    : > "$ZSHRC.$NAME.tmp"
fi
{
    printf '\n%s\n' "$BEGIN"
    # an oh-my-zsh plugins=(... zsh-venv-auto) entry has loaded it already
    printf '(( $+functions[auto_activate_venv] )) || source "%s"\n' "$source_path"
    printf '(( $+functions[auto_activate_venv] )) && auto_activate_venv\n'
    printf '%s\n' "$END"
} >> "$ZSHRC.$NAME.tmp"
# cat keeps a symlinked .zshrc and its permissions
cat "$ZSHRC.$NAME.tmp" > "$ZSHRC"
rm -f "$ZSHRC.$NAME.tmp"

printf 'Installed %s to %s\n' "$NAME" "$target"
if [ -n "$backup" ]; then
    printf 'Added it to the end of %s (the previous one is %s)\n' "$ZSHRC" "$backup"
else
    printf 'Created %s\n' "$ZSHRC"
fi
printf 'Open a new zsh, or run: exec zsh\n'
