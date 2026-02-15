# Terminal Setup - Windows

This guide sets up WezTerm as the terminal emulator with PowerShell and Starship prompt, matching the workflow on other platforms while optimized for Windows.

## 1. Install Fonts

Install Nerd Fonts (FiraCode) for icons and ligatures support.

```powershell
winget install -e --id DEVCOM.JetBrainsMonoNerdFont
```

Or install FiraCode specifically:
```powershell
winget search "Nerd Font"
# Choose from available options, e.g.:
winget install -e --id "Gyan.Nerd-Fonts.FiraCode"
```

## 2. Install WezTerm

Install WezTerm terminal emulator for a modern cross-platform experience.

```powershell
winget install --id wez.wezterm
```

**Configuration**:
Copy the provided configuration file to your home directory:

```powershell
cp config/wezterm.lua $env:USERPROFILE\.wezterm.lua
```

## 3. Install Starship Prompt

The cross-shell prompt that makes your terminal generic and informative.

```powershell
winget install --id Starship.Starship
```

**Configuration**:
Copy the configuration file:

```powershell
mkdir -Force $env:USERPROFILE\.config
cp config/starship.toml $env:USERPROFILE\.config\starship.toml
```

See [installation](https://starship.rs/guide/) and [configuration](https://starship.rs/config/) docs.

## 4. Install Modern CLI Tools

Enhance the terminal experience with modern replacements for standard tools.

### Eza (Better `ls`)

```powershell
winget install eza-community.eza
```

### Bat (Better `cat`)

```powershell
winget install sharkdp.bat
```

### Zoxide (Smarter `cd`)

```powershell
winget install ajeetdsouza.zoxide
```

### Ripgrep (Better `grep`)

```powershell
winget install BurntSushi.ripgrep.MSVC
```

### Fd (Better `find`)

```powershell
winget install sharkdp.fd
```

### Fzf (Fuzzy Finder)

```powershell
winget install fzf
```

### Additional Tools

```powershell
winget install Git.Git
winget install jqlang.jq
```

## 5. Configure PowerShell Profile

Copy the provided PowerShell profile to `$PROFILE`:

```powershell
New-Item -Path $PROFILE -Type File -Force
cp windows/config/Microsoft.PowerShell_profile.ps1 $PROFILE
```

## 6. Restart Terminal

Close and reopen your terminal (or launch WezTerm) to see the changes take effect.

## Verification

After setup, verify everything is working:

```powershell
# Check versions
starship --version
eza --version
bat --version
zoxide --version

# Test modern tools
ls    # Should show icons (via eza)
ll    # Detailed list with icons
cat $PROFILE  # Should use bat with syntax highlighting
```