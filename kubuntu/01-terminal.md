## Install FiraCode

Download, extract, and install font:
```shell
cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip FiraCode.zip
mkdir -p ~/.local/share/fonts
mv *.ttf ~/.local/share/fonts
fc-cache -fv
```

## Setup Konsole profile

Create profile file *~/.local/share/konsole/USER.profile*:
```shell
mkdir -p ~/.local/share/konsole
```

Profile content:
```profile
[Appearance]
BoldIntense=false
Font=FiraCode Nerd Font,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[General]
Name=USER
Parent=FALLBACK/
TerminalColumns=120
TerminalRows=30
```

Press *Ctrl+Shift+M* to toggle toolbar and set as default profile.

## Install starship

Follow the [installation](https://starship.rs/guide/) and [configuration](https://starship.rs/config/) guides.

## Install bat

```shell
sudo apt install bat
```

Add to *~/.bash_aliases*:
```bash
alias cat="batcat"
```

## Install ripgrep

```shell
sudo apt install ripgrep
```

Add to *~/.bash_aliases*:
```bash
alias grep="rg"
```

## Install fzf

```shell
sudo apt install fzf
```

Add to *~/.bashrc*:
```bash
eval "$(fzf --bash)"
bind '"\e[1;5A": "\C-r"'
```

## Install eza

Install [eza](https://eza.rocks/#debian-and-ubuntu).

Add to *~/.bash_aliases*:
```bash
alias ls="eza --icons"
alias ll="eza -l --icons"
alias la="eza -la --icons"
```
