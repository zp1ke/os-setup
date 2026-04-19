# Terminal Setup - Windows

This guide sets up Microsoft Terminal with PowerShell and Starship prompt, matching the workflow on other platforms while staying native to Windows.

## 1. Install Fonts

Install a Nerd Font for icons and ligatures support.

```powershell
winget install -e --id DEVCOM.JetBrainsMonoNerdFont
```

Or install FiraCode specifically:
```powershell
winget search "Nerd Font"
# Choose from available options, e.g.:
winget install -e --id "Gyan.Nerd-Fonts.FiraCode"
```

## 2. Install Microsoft Terminal

Install Microsoft Terminal. It is often preinstalled on Windows 11, but using `winget` keeps the setup explicit.

```powershell
winget install --id Microsoft.WindowsTerminal
```

**Configuration**:
Copy the provided settings file into Microsoft Terminal's settings location:

```powershell
$terminalSettings = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
Copy-Item $terminalSettings "$terminalSettings.bak" -ErrorAction SilentlyContinue
Copy-Item windows/config/windows-terminal.settings.json $terminalSettings
```

The provided settings configure:
- **Nerd Font rendering** for icons and ligatures
- **120x30 startup size** for a readable workspace
- **Padding and transparency** for aesthetics
- **Longer scrollback** (3500 lines) for history
- **Home directory as starting location** (instead of System32)

## 3. Install Starship Prompt

The cross-shell prompt that makes your terminal generic and informative.

**Important**: Starship requires PowerShell 7+ (not the legacy Windows PowerShell 5.1 that comes built-in).

```powershell
winget install --id Starship.Starship
winget install --id Microsoft.PowerShell
```

**Configuration**:
Copy the configuration file:

```powershell
mkdir -Force $env:USERPROFILE\.config
cp windows/config/starship.toml $env:USERPROFILE\.config\starship.toml
```

Then in Microsoft Terminal settings, select **PowerShell** (not "Windows PowerShell") as your default profile. You can find the latest PowerShell version in the Profiles list after installation.

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

Close and reopen Microsoft Terminal to see the changes take effect.

## Note: Fish Shell on Windows

Fish is a Unix shell and does not run natively on Windows. To use Fish on Windows, you must use **Windows Subsystem for Linux (WSL)**:

1. Install WSL: `wsl --install` (requires Windows 10/11)
2. Install a Linux distro (Ubuntu, Debian, etc.)
3. Run Fish in the WSL terminal

Alternatively, PowerShell 7+ with Starship provides a modern, cross-platform shell experience comparable to Fish without requiring WSL.

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
wt    # Should launch Microsoft Terminal
```

## Install Mise (Runtime Manager)

Use `mise` to manage Java, Node.js, and other development runtimes instead of separate tools.

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://mise.run/install.ps1 | iex"
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
Remove-Item Alias:ls -ErrorAction SilentlyContinue

function ls {
  eza --icons @args
}

function ll {
  eza -l --icons @args
}

function la {
  eza -la --icons @args
}
```

## Install Mise (Runtime Manager)

Use `mise` to manage Java, Node.js, and other development runtimes instead of separate tools.

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://mise.run/install.ps1 | iex"
```

Add to PowerShell profile (`$PROFILE`):

```powershell
if (Test-Path "$HOME/.local/bin/mise.exe") {
  $env:PATH = "$HOME/.local/bin;$env:PATH"
  (& "$HOME/.local/bin/mise.exe" activate pwsh) | Out-String | Invoke-Expression
}
```

Install global runtimes:

```powershell
mise use --global java@temurin-21
mise use --global node@22
```

Project runtimes:

```powershell
cd C:/path/to/project
mise use java@temurin-17 node@20
mise install
```
