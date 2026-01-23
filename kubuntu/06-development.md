# Development Tools - Kubuntu

This guide covers essential development tools for Kubuntu.

Prerequisite: complete [Terminal Setup](01-terminal.md) (Fish + WezTerm + Starship).

## 1. Common (Shell-Agnostic)

This section covers the common workflows and commands regardless of which shell you use.
Shell-specific setup (Fish/Bash) lives in the next sections.

### Direnv

[direnv](https://direnv.net/) loads and unloads environment variables based on the current directory.

Install:
```bash
sudo apt install direnv
```

Usage — create `.envrc` in your project directory:
```bash
cd /path/to/your/project
echo 'export PROJECT_VAR="value"' > .envrc
direnv allow
```

Common `.envrc` examples:
```bash
# .envrc examples
export PATH="$PWD/bin:$PATH"
export DATABASE_URL="postgresql://localhost/mydb"
use node 18
```

**Note:** Always add `.envrc` to `.gitignore` if it contains secrets.

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

If you want KDE Wallet / GUI prompts integration (`ksshaskpass`), see the Fish/Bash sections below.

### JDK

This setup prefers [jenv](http://www.jenv.be/) for Java version selection.

#### Install jenv

On Kubuntu/Linux, install from source:
```bash
sudo apt update
sudo apt install -y git
git clone https://github.com/jenv/jenv.git ~/.jenv
```

Shell initialization is required for `jenv` to work (see the Fish/Bash sections below).

#### Install a JDK

`jenv` does not install Java for you. Use one of these:

Option A — Ubuntu packages (simple, version availability depends on your Kubuntu release):
```bash
sudo apt install -y default-jdk
```

Option B — Adoptium (recommended when you need a specific version like 21):
- Download from: https://adoptium.net/temurin/releases?mode=filter&os=linux&arch=x64
- Extract somewhere stable, e.g. `~/.jdk/jdk-21`

#### Add JDK(s) to jenv

After installing Java, add a JDK home to `jenv`:
```bash
# list candidate JDK folders
ls -1 /usr/lib/jvm

# examples (pick the one that exists)
jenv add /usr/lib/jvm/default-java
jenv add /usr/lib/jvm/java-21-openjdk-amd64

# or for Adoptium/manual installs
jenv add ~/.jdk/jdk-21
```

Set a default and verify:
```bash
jenv versions
jenv global 21
jenv doctor
```

Optional (recommended): enable automatic `JAVA_HOME` export:
```bash
jenv enable-plugin export
```

### Node.js

This setup prefers [fnm](https://github.com/Schniz/fnm) for Node.js version selection.

#### Install fnm

The fnm installer needs `curl` and `unzip`:
```bash
sudo apt update
sudo apt install -y curl unzip
```

Install `fnm` and avoid it auto-editing your shell config (we configure Fish/Bash below):
```bash
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
```

#### Install Node

After enabling fnm in your shell (see the Fish/Bash sections below):
```bash
fnm --version

# install latest LTS and use it
fnm install --lts
fnm use --lts

node --version
npm --version
```

Project pinning:
```bash
node --version > .node-version
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

## 2. Fish

Recommended for this setup (see [Terminal Setup](01-terminal.md)).

Create a dedicated dev config that Fish loads automatically:
```bash
mkdir -p ~/.config/fish/conf.d
$EDITOR ~/.config/fish/conf.d/dev.fish
```

Suggested content:
```fish
# direnv
if type -q direnv
    direnv hook fish | source
end

# Git (KDE Wallet / GUI prompts)
set -gx GIT_ASKPASS /usr/bin/ksshaskpass

# jenv
set -gx JENV_HOME $HOME/.jenv
if test -d $JENV_HOME
    set -x PATH $JENV_HOME/bin $PATH
    status --is-interactive; and jenv init - | source
end

# fnm
set -gx FNM_HOME $HOME/.local/share/fnm
if test -d $FNM_HOME
    set -x PATH $FNM_HOME $PATH
    fnm env --use-on-cd --shell fish | source
end

# flutter
set -gx FLUTTER_HOME $HOME/.local/share/flutter
if test -d $FLUTTER_HOME
    set -x PATH $FLUTTER_HOME/bin $PATH
end

# android
set -gx ANDROID_HOME $HOME/.android-sdk
if test -d $ANDROID_HOME
    set -gx ANDROID_SDK_ROOT $ANDROID_HOME
    set -x PATH $ANDROID_HOME/platform-tools $PATH
    set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
end
```

## 3. Bash (Legacy / Reference)

If you still use Bash, keep a separate dev file and source it from `~/.bashrc`.

Create `~/.bash_dev` and add it to `~/.bashrc`:
```bash
# Dev environment
if [ -f ~/.bash_dev ]; then
  . ~/.bash_dev
fi
```

Add to `~/.bash_dev`:
```bash
# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# Git (KDE Wallet / GUI prompts)
export GIT_ASKPASS=/usr/bin/ksshaskpass

# JEnv
JENV_HOME="$HOME/.jenv"
if [ -d "$JENV_HOME" ]; then
  export PATH="$JENV_HOME/bin:$PATH"
  eval "$(jenv init -)"
fi

# fnm
FNM_HOME="$HOME/.local/share/fnm"
if [ -d "$FNM_HOME" ]; then
  export PATH="$FNM_HOME:$PATH"
  eval "$(fnm env --use-on-cd --shell bash)"
fi

# flutter
FLUTTER_HOME="$HOME/.local/share/flutter"
if [ -d "$FLUTTER_HOME" ]; then
  export PATH="$FLUTTER_HOME/bin:$PATH"
fi

# android
export ANDROID_HOME="$HOME/.android-sdk"
if [ -d "$ANDROID_HOME" ]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  export PATH="$ANDROID_HOME/platform-tools:$PATH"
  export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
fi
```
