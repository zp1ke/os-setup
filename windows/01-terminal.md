# Terminal Setup

## Install FiraCode Nerd Font

Download [FiraCode.zip](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip), extract, and install fonts.

## Install Starship

```shell
winget install --id Starship.Starship
```

See [installation](https://starship.rs/guide/) and [configuration](https://starship.rs/config/) docs.

## Install Eza

```shell
winget install eza-community.eza
```

Add to PowerShell profile (`$PROFILE`):

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