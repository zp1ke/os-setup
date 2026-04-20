# Development Tools - Kubuntu

This guide covers essential development tools for Kubuntu.

Prerequisite: complete [Terminal Setup](01-terminal.md) (Fish + Ghostty + Starship).

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

### Runtimes (Java, Node.js, and More)

This setup uses [mise](https://mise.jdx.dev/) for runtime version management.

## Mise (Java, Node.js, and More)

[mise](https://mise.jdx.dev/) is the single runtime manager for development tools. Use it instead of jenv/fnm/nvm.

Install mise:
```shell
curl https://mise.run | sh
```

If you use Bash, add to `.bash_dev`:
```bash
# mise
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$($HOME/.local/bin/mise activate bash)"
fi
```

If you use Fish (recommended in this repo), activation is shown in the Fish section below.

Install global runtimes:
```shell
mise use --global java@temurin-21
mise use --global node@22
mise install
```

Project-specific runtimes:
```shell
cd /path/to/project
mise use java@temurin-17 node@20
mise install
```

Verify:
```shell
mise --version
mise ls
java -version
node -v
npm -v
```

## Docker

Follow the [installation guide](https://docs.docker.com/engine/install/ubuntu/) and [post-install steps](https://docs.docker.com/engine/install/linux-postinstall/).

### GitHub Desktop

Follow the [installation guide](https://linuxcapable.com/how-to-install-github-desktop-on-ubuntu-linux/).

### Flutter & Android

Follow guides for [Android](https://docs.flutter.dev/get-started/install/linux/android) and [Desktop](https://docs.flutter.dev/get-started/install/linux/desktop).

Verify setup:
```bash
flutter doctor
```

## 2. Fish

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
