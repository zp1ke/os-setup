# Development Tools - macOS

This guide covers essential development tools for macOS.

## Prerequisites

Make sure you have completed the [Terminal Setup](01-terminal.md) which includes Homebrew and Fish shell.

## Direnv

[direnv](https://direnv.net/) loads and unloads environment variables based on the current directory.

### Install

```bash
brew install direnv
```

Direnv integration is already configured in `~/.config/fish/config.fish` (see [Terminal Setup](01-terminal.md)).

### Usage

Create `.envrc` in your project directory:
```bash
cd /path/to/your/project
echo 'export PROJECT_VAR="value"' > .envrc
direnv allow
```

Common use cases:
```bash
# .envrc examples
export PATH="$PWD/bin:$PATH"
export DATABASE_URL="postgresql://localhost/mydb"
layout python python3.11
```

**Note:** Always add `.envrc` to `.gitignore` if it contains secrets.

## JDK

### Install jenv

[jenv](http://www.jenv.be/) is a version manager for Java, similar to how nvm manages Node.js versions.

```bash
brew install jenv
```

### Configure Fish Shell

Add jenv initialization to your Fish config:

```bash
# Add to ~/.config/fish/config.fish
# jenv
if test -d ~/.jenv
    set -x PATH ~/.jenv/bin $PATH
    status --is-interactive; and jenv init - | source
end
```

Or append it directly:
```bash
echo '
# jenv
if test -d ~/.jenv
    set -x PATH ~/.jenv/bin $PATH
    status --is-interactive; and jenv init - | source
end' >> ~/.config/fish/config.fish
```

### Install JDK

Download JDK from [Adoptium](https://adoptium.net/temurin/releases?mode=filter&os=mac&arch=x64) or use Homebrew:

#### Option 1: Using Homebrew (Recommended)

```bash
# Install specific Java versions
brew install openjdk@21
brew install openjdk@17
brew install openjdk@11

# Symlink the JDK (for system-wide use, optional)
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
```

#### Option 2: Manual Installation

Download from Adoptium and extract to `~/.jdk/`:
```bash
mkdir -p ~/.jdk
cd ~/Downloads

# Extract the tar.gz file (replace with your actual filename)
tar -xzf OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.5_11.tar.gz

# Move to ~/.jdk/
mv jdk-21.0.5+11 ~/.jdk/jdk-21

# For other versions:
# tar -xzf OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.13_11.tar.gz
# mv jdk-17.0.13+11 ~/.jdk/jdk-17
```

**Note:** For Intel Macs, the filename will have `x64` instead of `aarch64`. The extracted directory name format is usually `jdk-<version>+<build>`, which you can rename to something simpler like `jdk-21` when moving.

### Add JDK versions to jenv

```bash
# For Homebrew-installed JDKs
jenv add /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
jenv add /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
jenv add /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home

# For manually installed JDKs
jenv add ~/.jdk/jdk-21/Contents/Home

# Set global Java version
jenv global 21

# Verify
jenv versions
jenv doctor
```

### Enable jenv plugins

First, ensure the plugins directory exists:
```bash
mkdir -p ~/.jenv/plugins
```

Then enable the plugins:
```bash
# Export JAVA_HOME automatically (do this first)
jenv enable-plugin export

# Maven integration
jenv enable-plugin maven

# Gradle integration
jenv enable-plugin gradle
```

**Note:** If `jenv enable-plugin export` still fails, you may need to update jenv:
```bash
brew upgrade jenv
# Then restart your terminal
```

### Verification

```bash
# Check Java version
java -version

# Check JAVA_HOME
echo $JAVA_HOME

# List all managed versions
jenv versions
```

### Per-project Java version

```bash
# Set Java version for current directory
cd /path/to/your/project
jenv local 17

# This creates a .java-version file
cat .java-version
```

## Troubleshooting

### jenv doctor warnings

If `jenv doctor` shows warnings about JAVA_HOME:
```bash
jenv enable-plugin export
```

### Fish shell not recognizing jenv

Make sure you've restarted your terminal or run:
```bash
source ~/.config/fish/config.fish
```

### Java version not switching

Check if `.java-version` file exists in your project directory and verify with:
```bash
jenv version
```
