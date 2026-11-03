## zsh-venv-auto

* oh-my-zsh plugin
* Automatically activates the Python virtual environment of the project you change directory into, and deactivates it when you leave
* Looks in the current directory and each parent for `venv`, `env`, `.venv` or `.env` with `bin/activate` (or `Scripts/activate`); the nearest one wins
* Runs on every directory change, `cd`, `pushd` and AUTO_CD alike, as a `chpwd` hook
* On the next directory change, a venv inherited from a parent shell is taken off `PATH`, and one activated by hand is closed with its own `deactivate`
* For PowerShell, use [pwsh-venv-auto](https://github.com/peppy0510/pwsh-venv-auto)

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/peppy0510/zsh-venv-auto/main/install.sh | sh
```

* Works with or without oh-my-zsh; it goes in `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins` when oh-my-zsh is there, `~/.zsh-venv-auto` otherwise, and downloads with `git`, or `curl`/`wget` when `git` is missing
* Appends a marked block to the end of `~/.zshrc`, after a backup; the first activation has to come after every `PATH` export, as `deactivate` restores the `PATH` it saw
* Open a new zsh, or run `exec zsh`

#### Manually, as an oh-my-zsh plugin

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

* Run the installation command again, which also moves the block back to the end of `~/.zshrc`, or pull the clone:

```bash
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-venv-auto pull
```

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/peppy0510/zsh-venv-auto/main/uninstall.sh | sh
```

* Removes the block, a `zsh-venv-auto` entry in `plugins`, the initial activation line and the plugin folder, after backing up `~/.zshrc`
