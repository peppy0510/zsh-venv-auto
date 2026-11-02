## zsh-venv-auto

* oh-my-zsh plugin
* Automatically activates the Python virtual environment of the project you change directory into, and deactivates it when you leave
* Looks in the current directory and each parent for `venv`, `env`, `.venv` or `.env` with `bin/activate` (or `Scripts/activate`); the nearest one wins
* Runs on every directory change, `cd`, `pushd` and AUTO_CD alike, as a `chpwd` hook
* On the next directory change, a venv inherited from a parent shell is taken off `PATH`, and one activated by hand is closed with its own `deactivate`
* For PowerShell, use [pwsh-venv-auto](https://github.com/peppy0510/pwsh-venv-auto)

### Installation

```bash
git clone https://github.com/peppy0510/zsh-venv-auto.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-venv-auto
```
* Add `zsh-venv-auto` to `~/.zshrc` `plugins` section.

```bash
vim ~/.zshrc
```

```bash
zsh-venv-auto
```

* Add the initial activation to the end of `~/.zshrc`, below every `PATH` export.

```bash
(( $+functions[auto_activate_venv] )) && auto_activate_venv
```

### Update

```bash
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-venv-auto pull
```
