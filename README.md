## ZSH Auto Activate Python VENV

### Description

* Automaticall activate and deactivate Python Virtual Environment when you change directory
* Installed Virtual Environment directory name must be one of `venv`, `env`, `.venv`, `.env`
* oh-my-zsh should be installed

### Installation

```bash
git clone https://github.com/peppy0510/zsh-auto-activate-python-venv.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-auto-activate-python-venv
```
* Add `zsh-auto-activate-python-venv` to `~/.zshrc` `plugins` section.

```bash
vim ~/.zshrc
```

```bash
plugins=(
    zsh-auto-activate-python-venv
)
```
