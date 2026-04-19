# Development Tools - macOS

This guide covers essential development tools for macOS.

## Prerequisites

Make sure you have completed the [Terminal Setup](01-terminal.md) which includes Homebrew and Fish shell.

## Mise (Java, Node.js, and More)

[mise](https://mise.jdx.dev/) is the single runtime manager for development tools. Use it instead of separate tools like jenv, fnm, or nvm.

[mise](https://mise.jdwp.dev/) is a polyglot runtime version manager that handles Java, Node.js, Python, and many other languages.

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
