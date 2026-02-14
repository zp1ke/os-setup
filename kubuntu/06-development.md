# Development Tools - Kubuntu

This guide covers essential development tools for Kubuntu.

Prerequisite: complete [Terminal Setup](01-terminal.md) (Fish + WezTerm + Starship).

## 1. Common (Shell-Agnostic)

This section covers the common workflows and commands regardless of which shell you use.
Shell-specific setup (Fish) is in the next section.

### Git

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
```

Add key to `ssh-agent`:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Verify SSH connection:
```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```

If you want KDE Wallet / GUI prompts integration (`ksshaskpass`), see the Fish section below.

### JDK

This setup uses [mise](https://mise.jdwp.dev/) for Java version management.

#### Mise is installed globally

Mise is installed and configured in the "Runtime Environment" section below. Java versions are managed through mise.

#### Install Java versions

Once mise is configured, install Java:
```bash
# Install a specific version
mise install java@21
mise install java@17
mise install java@11

# Set a global default
mise use --global java@21

# Verify
java -version
echo $JAVA_HOME
```

#### Per-project Java version

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

### Node.js

This setup uses [mise](https://mise.jdwp.dev/) for Node.js version management.

#### Mise is installed globally

Mise is installed and configured in the "Runtime Environment" section below. Node.js versions are managed through mise.

#### Install Node.js versions

Once mise is configured, install Node.js:
```bash
# Install a specific version
mise install node@20
mise install node@18

# Set a global default
mise use --global node@20

# Verify
node --version
npm --version
```

#### Per-project Node.js version

Create a `.mise.toml` file in your project:
```toml
[tools]
node = "18"
```

Or use the command:
```bash
cd /path/to/your/project
mise use node@18
```

### Docker

Follow the [installation guide](https://docs.docker.com/engine/install/ubuntu/) and [post-install steps](https://docs.docker.com/engine/install/linux-postinstall/).

### GitHub Desktop

Follow the [installation guide](https://linuxcapable.com/how-to-install-github-desktop-on-ubuntu-linux/).

### Flutter & Android

Follow guides for [Android](https://docs.flutter.dev/get-started/install/linux/android) and [Desktop](https://docs.flutter.dev/get-started/install/linux/desktop).

Verify setup:
```bash
flutter doctor
```

## 2. Runtime Environment

### Mise Installation

[mise](https://mise.jdwp.dev/) is a polyglot runtime version manager that handles Java, Node.js, Python, and many other languages.

Install mise:
```bash
curl https://mise.jdwp.dev/install.sh | sh
```

Shell configuration is in the Fish section below.

## 3. Fish

Recommended for this setup (see [Terminal Setup](01-terminal.md)).

Create a dedicated dev config that Fish loads automatically:
```bash
mkdir -p ~/.config/fish/conf.d
$EDITOR ~/.config/fish/conf.d/dev.fish
```

Suggested content:
```fish
# Git (KDE Wallet / GUI prompts)
set -gx GIT_ASKPASS /usr/bin/ksshaskpass

# mise
if type -q mise
    mise activate fish | source
end

# flutter
set -gx FLUTTER_HOME $HOME/.local/share/flutter
if test -d $FLUTTER_HOME
  fish_add_path --append $FLUTTER_HOME/bin
end

# android
set -gx ANDROID_HOME $HOME/.android-sdk
if test -d $ANDROID_HOME
   set -gx ANDROID_SDK_ROOT $ANDROID_HOME
  fish_add_path --append $ANDROID_HOME/platform-tools
  fish_add_path --append $ANDROID_HOME/cmdline-tools/latest/bin
end
```
