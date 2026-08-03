## zsh-venv-auto

* oh-my-zsh plugin
* Automaticall activate and deactivate Python Virtual Environment when you change directory
* Installed Virtual Environment directory name must be one of `venv`, `env`, `.venv`, `.env`

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
