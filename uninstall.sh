#!/bin/sh
# author: Taehong Kim
# email: peppy0510@hotmail.com
#
# curl -fsSL https://raw.githubusercontent.com/peppy0510/zsh-venv-auto/main/uninstall.sh | sh
#
# Takes out what install.sh added and what the manual installation asks for: the block at the
# end of ~/.zshrc, a zsh-venv-auto entry in plugins=(...), the initial activation line, and the
# plugin folder. ~/.zshrc is backed up first.

set -eu

NAME='zsh-venv-auto'
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
BEGIN="# >>> $NAME >>>"
END="# <<< $NAME <<<"

if [ -f "$ZSHRC" ]; then
    backup="$ZSHRC.bak-$NAME-$(date +%Y%m%d%H%M%S)"
    cp -p "$ZSHRC" "$backup"
    awk -v begin="$BEGIN" -v end="$END" -v name="$NAME" '
        $0 == begin { skip = 1; next }
        $0 == end { skip = 0; next }
        skip { next }
        /^[[:space:]]*\(\( \$\+functions\[auto_activate_venv\] \)\) && auto_activate_venv[[:space:]]*$/ { next }
        /^[[:space:]]*plugins=\(/ { inside = 1 }
        inside {
            line = $0
            # the name as a whole word, wherever it sits in the list
            while (match(line, "(^|[[:space:](])" name "([[:space:])]|$)")) {
                head = substr(line, 1, RSTART - 1)
                tail = substr(line, RSTART + RLENGTH)
                keep = substr(line, RSTART, RLENGTH)
                sub(name, "", keep)
                line = head keep tail
            }
            if (line ~ /\)/) inside = 0
            if (line ~ /^[[:space:]]*$/ && $0 !~ /^[[:space:]]*$/) next
            print line
            next
        }
        { print }
    ' "$backup" > "$ZSHRC.$NAME.tmp"
    # cmp is not in every minimal image
    if [ "$(cat "$ZSHRC.$NAME.tmp")" = "$(cat "$backup")" ]; then
        rm -f "$ZSHRC.$NAME.tmp" "$backup"
        printf '%s had nothing of %s\n' "$ZSHRC" "$NAME"
    else
        cat "$ZSHRC.$NAME.tmp" > "$ZSHRC"
        rm -f "$ZSHRC.$NAME.tmp"
        printf 'Removed %s from %s (the previous one is %s)\n' "$NAME" "$ZSHRC" "$backup"
    fi
fi

for target in "${ZSH_CUSTOM:-}/plugins/$NAME" "${ZSH:-$HOME/.oh-my-zsh}/custom/plugins/$NAME" "$HOME/.$NAME"; do
    case "$target" in /plugins/*) continue ;; esac
    if [ -f "$target/$NAME.plugin.zsh" ]; then
        rm -rf "$target"
        printf 'Removed %s\n' "$target"
    fi
done

printf 'Open a new zsh, or run: exec zsh\n'
