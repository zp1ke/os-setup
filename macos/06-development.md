# Development Tools - macOS

This guide covers essential development tools for macOS.

## Prerequisites

Make sure you have completed the [Terminal Setup](01-terminal.md) which includes Homebrew and Fish shell.

## Git

Set global values:
```bash
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@users.noreply.github.com"
```

Setup SSH keys (restore from backup if you have one):
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /path/to/backup/.ssh/id_ed25519* ~/.ssh/
cp /path/to/backup/.ssh/config ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/config
chmod 644 ~/.ssh/id_ed25519.pub
```

Add key to `ssh-agent` and save passphrase to Keychain:
```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

If you need a minimal SSH config for GitHub/GitLab:
```ssh-config
Host github.com gitlab.com
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_ed25519
```

Verify SSH connection:
```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```

## Mise (Java, Node.js, and More)

[mise](https://mise.jdx.dev/) is the single runtime manager for development tools. It handles Java, Node.js, Python, and many other languages.

Install mise:
```bash
brew install mise
```

Fish activation is handled in `~/.config/fish/config.fish` from the terminal setup.

### Install Global Runtime Versions

```bash
# Java (Temurin)
mise use --global java@temurin-21
mise use --global java@temurin-17

# Node.js
mise use --global node@22
mise use --global node@20
```

### Per-project Runtime Versions

```bash
cd /path/to/your/project

# Creates/updates mise.toml in the current project
mise use java@temurin-17 node@20

# Install all versions declared in mise.toml
mise install
```

### Verification

```bash
mise --version
mise ls
java -version
node -v
npm -v
```

## Troubleshooting

### Runtime command not found

Reload fish:

```bash
source ~/.config/fish/config.fish
```

### Wrong runtime version in a project

Verify active versions and local configuration:

```bash
mise current
cat mise.toml
```
