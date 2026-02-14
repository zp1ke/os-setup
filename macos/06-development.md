# Development Tools - macOS

This guide covers essential development tools for macOS.

## Prerequisites

Make sure you have completed the [Terminal Setup](01-terminal.md) which includes Homebrew and Fish shell.

## Runtime Environment

### Mise Installation

[mise](https://mise.jdwp.dev/) is a polyglot runtime version manager that handles Java, Node.js, Python, and many other languages.

Install mise:
```bash
curl https://mise.jdwp.dev/install.sh | sh
```

Add mise to your Fish config (update your `~/.config/fish/config.fish`):
```fish
# mise
if type -q mise
    mise activate fish | source
end
```

Or append it directly:
```bash
echo '
# mise
if type -q mise
    mise activate fish | source
end' >> ~/.config/fish/config.fish
```

## JDK

### Install Java versions

Once mise is installed and configured, install Java:
```bash
# Install specific versions
mise install java@21
mise install java@17
mise install java@11

# Set a global default
mise use --global java@21

# Verify
java -version
echo $JAVA_HOME
```

### Per-project Java version

Create a `.mise.toml` file in your project:
```toml
[tools]
java = "17"
```

Or use the command:
```bash
cd /path/to/your/project
mise use java@17
```

### Verification

```bash
# Check Java version
java -version

# Check JAVA_HOME
echo $JAVA_HOME
```
