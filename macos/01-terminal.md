# Terminal Setup - macOS

This guide sets up WezTerm as the terminal emulator with Fish shell and Starship prompt.

## Prerequisites

Install Homebrew if not already installed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. Install WezTerm

```bash
brew install --cask wezterm
```

## 2. Install Fish Shell

```bash
brew install fish

# Find where fish was installed
which fish

# Add fish to the list of allowed shells (use the path from 'which fish')
# For Apple Silicon Macs (M1/M2/M3): /opt/homebrew/bin/fish
# For Intel Macs: /usr/local/bin/fish
which fish | sudo tee -a /etc/shells

# Set fish as default shell (use the path from 'which fish')
chsh -s $(which fish)
```

## 3. Install Starship Prompt

```bash
brew install starship
```

## 4. Install Modern CLI Tools

Install the "Cool Factor" tools from the NixOS configuration:

```bash
# Modern replacements for core utilities
brew install eza      # Better 'ls'
brew install bat      # Better 'cat'
brew install zoxide   # Smarter 'cd'
brew install direnv   # Per-directory environments
brew install fzf      # Fuzzy finder
brew install ripgrep  # Better 'grep'
brew install fd       # Better 'find'

# Additional tools
brew install git
brew install btop     # Modern task manager
brew install tree
brew install jq       # JSON processor
```

## 5. Install Nerd Fonts

Required for icons in the terminal:

```bash
brew install font-jetbrains-mono-nerd-font
brew install font-fira-code-nerd-font
brew install font-caskaydia-cove-nerd-font
```

## 6. Deploy Configuration Files

Copy the configuration files to their proper locations:

```bash
# Create config directories
mkdir -p ~/.config/wezterm
mkdir -p ~/.config/fish
mkdir -p ~/.local/share/fish

# Copy WezTerm config
cp config/wezterm.lua ~/.config/wezterm/wezterm.lua

# Copy Starship config
cp config/starship.toml ~/.config/starship.toml

# Copy Fish config
cp config/config.fish ~/.config/fish/config.fish
```

## 7. Restart Terminal

Close and reopen your terminal (or launch WezTerm) to see the changes take effect.

## Verification

After setup, verify everything is working:

```bash
# Check Fish version
fish --version

# Check Starship version
starship --version

# Test modern tools
ls    # Should show icons (via eza)
ll    # Detailed list with icons
cat ~/.config/starship.toml  # Should use bat with syntax highlighting
```

## Troubleshooting

### Permission denied creating ~/.local/share/fish
If you get permission denied, check the ownership of your home directory:
```bash
ls -la ~ | grep "^\."
sudo chown -R $(whoami):staff ~/.local
mkdir -p ~/.local/share/fish
```

### Fish not showing as default
Make sure you've added fish to `/etc/shells` and run `chsh -s $(which fish)`. The fish path varies by Mac architecture (Intel vs Apple Silicon).

### Icons not displaying
Make sure you've installed a Nerd Font and selected it in WezTerm's configuration.

### Starship not loading
Check that `~/.config/starship.toml` exists and Fish is sourcing it via `config.fish`.
