# Terminal Setup - Kubuntu

This guide uses KDE Konsole with Fish shell and Starship prompt, matching the same cross-platform workflow.

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

## 2. Configure Konsole

Konsole is the default terminal on Kubuntu. Ensure it is installed and set as the default terminal handler.

```bash
sudo apt update
sudo apt install -y konsole

# Keep Konsole as KDE's default terminal entry points (Plasma 6)
kwriteconfig6 --file kdeglobals --group General --key TerminalApplication konsole
kwriteconfig6 --file kdeglobals --group General --key TerminalService org.kde.konsole.desktop
```

### Create a Konsole profile (recommended defaults)

Create a profile with these defaults:

- Font: `FiraCode Nerd Font`
- Font size: `14`
- Initial size: `120x30`
- Scrollback: `10000`
- Shell: `fish`

```bash
mkdir -p ~/.local/share/konsole
cp config/konsole/Main.profile ~/.local/share/konsole/Main.profile

# Make this profile the default
kwriteconfig6 --file konsolerc --group Desktop Entry --key DefaultProfile Main.profile
```

### Match the remaining behavior in GUI

Konsole does not map every setting in a single file, so set these in Konsole UI:

1. Open Konsole -> `Settings` -> `Edit Current Profile...`
2. `Appearance`:
    - Select a theme close to your preference (`Breeze`, `Breeze Dark`, or imported scheme)
    - Set background transparency around `90%` (if compositor/transparency is enabled)
3. `Tabs`:
    - Keep tab bar visible to mirror always-on tab behavior
4. `Scrolling`:
    - Keep scrollbar visible
    - Confirm scrollback is `10000`

Restart Konsole after creating/changing profiles.

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
