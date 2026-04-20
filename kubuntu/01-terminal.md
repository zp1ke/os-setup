# Terminal Setup - Kubuntu

This guide uses Ghostty with Fish shell and Starship prompt, matching the same cross-platform workflow.

## 1. Install Fonts

Install Nerd Fonts (FiraCode) for icons and ligatures support.

```bash
cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip FiraCode.zip
mkdir -p ~/.local/share/fonts
mv *.ttf ~/.local/share/fonts
fc-cache -fv
# Cleanup
rm FiraCode.zip LICENSE README.md
```

## 2. Install and Configure Ghostty

Ghostty is a fast, feature-rich terminal that automatically follows the KDE system light/dark theme.

```bash
sudo snap install ghostty --classic
```

### Set Ghostty as KDE's default terminal (Plasma 6)

```bash
kwriteconfig6 --file kdeglobals --group General --key TerminalApplication ghostty
kwriteconfig6 --file kdeglobals --group General --key TerminalService com.mitchellh.ghostty.desktop
```

### Apply configuration

Copy the configuration file:

```bash
mkdir -p ~/.config/ghostty
cp config/ghostty.conf ~/.config/ghostty/config.ghostty
```

The config uses `theme = "light:Catppuccin Latte,dark:Catppuccin Mocha"` so Ghostty automatically picks the right palette based on the KDE color scheme (light or dark).

## 3. Install Fish Shell

Install the latest Fish shell.

```bash
# Add PPA for latest version
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish

# Set as default shell
chsh -s /usr/bin/fish
```

**Configuration**:
Copy the configuration file:

```bash
mkdir -p ~/.config/fish
cp config/config.fish ~/.config/fish/config.fish
```

## 4. Install Starship Prompt

The cross-shell prompt that makes your terminal generic and informative.

```bash
curl -sS https://starship.rs/install.sh | sh
```

**Configuration**:
Copy the configuration file:

```bash
cp config/starship.toml ~/.config/starship.toml
```

## 5. Install Modern CLI Tools

Enhance the terminal experience with modern replacements for standard tools.

### Eza (Better `ls`)

```bash
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg arch=amd64] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

### Bat (Better `cat`)

```bash
sudo apt install bat
# Note: Ubuntu installs it as 'batcat', our fish config handles the alias
```

### Zoxide (Smarter `cd`)

```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

### Ripgrep (Better `grep`)

```bash
sudo apt install ripgrep
```

### Fd (Better `find`)

```bash
sudo apt install fd-find
```

### Fzf (Fuzzy Finder)

```bash
sudo apt install fzf
```
