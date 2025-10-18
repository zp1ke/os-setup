# Terminal Setup

## 1. Install FiraCode Nerd Font

Download [FiraCode.zip](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip), extract, and install the fonts.

## 2. Install Starship

```shell
winget install --id Starship.Starship
```

See [installation guide](https://starship.rs/guide/) and [configuration docs](https://starship.rs/config/) for customization.

## 3. Install Eza

```shell
winget install eza-community.eza
```

Add to your PowerShell profile (`$PROFILE`):

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