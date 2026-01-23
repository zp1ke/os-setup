# Terminal Setup - Kubuntu

This guide sets up WezTerm as the terminal emulator with Fish shell and Starship prompt, matching the workflow on other platforms while optimized for Kubuntu.

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

## 2. Install WezTerm

Install the latest WezTerm from the official repository.

```bash
# Add the GPG key and repository
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

# Install
sudo apt update
sudo apt install wezterm
```

**Configuration**:
Copy the provided configuration file to your home directory:

```bash
cp config/wezterm.lua ~/.wezterm.lua
```

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

---

## Alternative: Konsole Setup

If you prefer sticking with the default KDE Konsole, use the provided profile.

Create profile file `~/.local/share/konsole/USER.profile`:

```bash
mkdir -p ~/.local/share/konsole
# You can copy the content from elsewhere or configure it via GUI
```

Profile content references `FiraCode Nerd Font`.
