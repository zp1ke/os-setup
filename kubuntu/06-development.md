## Shell

Create file *.bash_dev* and add it to *.bashrc*:
```bash
#Dev environment
if [ -f ~/.bash_dev ]; then
  . ~/.bash_dev
fi
```

## Direnv

[direnv](https://direnv.net/) loads and unloads environment variables based on the current directory.

Install:
```shell
sudo apt install direnv
```

Add to `~/.bash_dev`:
```bash
# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi
```

Usage - create `.envrc` in your project directory:
```shell
cd /path/to/your/project
echo 'export PROJECT_VAR="value"' > .envrc
direnv allow
```

Common use cases:
```shell
```shell
# .envrc examples
export PATH="$PWD/bin:$PATH"
export DATABASE_URL="postgresql://localhost/mydb"
use node 18
```

**Note:** Add `.envrc` to `.gitignore` if it contains secrets.

**Note:** Always add `.envrc` to `.gitignore` if it contains secrets.

## Git

### Set global values
```shell
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@users.noreply.github.com"
```

### Setup ssh key

Create SSH directory and restore keys from backup:
```shell
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /path/to/backup/.ssh/id_ed25519* ~/.ssh/
cp /path/to/backup/.ssh/config ~/.ssh/config
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
```

Add key to ssh-agent:
```shell
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Verify SSH connection:
```shell
ssh -T git@github.com
ssh -T git@gitlab.com
```

Integrate with KDE Wallet in *.bash_dev*:
```bash
# Git
export GIT_ASKPASS=/usr/bin/ksshaskpass
```

## JDK

Follow [jenv guide](http://www.jenv.be/). Add to *.bash_dev*:
```bash
# JEnv
JENV_HOME="$HOME/.jenv"
if [ -d "$JENV_HOME" ]; then
  export PATH="$JENV_HOME/bin:$PATH"
  eval "$(jenv init -)"
fi
```

Download JDK from [Adoptium](https://adoptium.net/temurin/releases?mode=filter&os=linux&arch=x64), extract and add:
```shell
jenv add ~/.jdk/jdk-21
jenv global 21
jenv doctor
```

## NodeJS

Follow [fnm guide](https://github.com/Schniz/fnm). Add to *.bash_dev* (not *.bashrc*):
```bash
# fnm
FNM_HOME="$HOME/.local/share/fnm"
if [ -d "$FNM_HOME" ]; then
  export PATH="$FNM_HOME:$PATH"
  eval "$(fnm env --use-on-cd --shell bash)"
fi
```

## Docker

Follow the [installation guide](https://docs.docker.com/engine/install/ubuntu/) and [post-install steps](https://docs.docker.com/engine/install/linux-postinstall/).

## Github Desktop

Follow the [installation guide](https://linuxcapable.com/how-to-install-github-desktop-on-ubuntu-linux/).

## Flutter & Android

Follow guides for [Android](https://docs.flutter.dev/get-started/install/linux/android) and [Desktop](https://docs.flutter.dev/get-started/install/linux/desktop).

Add to *.bash_dev*:
```bash
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

Verify setup:
```shell
flutter doctor
```
