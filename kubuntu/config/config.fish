# Fish Shell Configuration for Kubuntu
# Based on NixOS configuration

# ===================================
# STARSHIP PROMPT
# ===================================
starship init fish | source

# ===================================
# ZOXIDE (Better cd)
# ===================================
# Ensure zoxide is installed
if type -q zoxide
    zoxide init fish | source
end

# ===================================
# DISABLE GREETING
# ===================================
set fish_greeting

# ===================================
# ALIASES - Modern CLI Tools
# ===================================

# Eza (better ls)
if type -q eza
    alias ls="eza --icons"
    alias ll="eza -l --icons --git --group-directories-first"
    alias la="eza -la --icons --git --group-directories-first"
end

# Bat (better cat)
# Ubuntu often installs as 'batcat', we map it to 'bat' if needed
if type -q batcat
    alias bat="batcat"
end
# --style=plain is good for 'cat' so you don't get grid lines when copying text
alias cat="bat --style=plain"

# Zoxide (better cd)
# Note: zoxide initializes 'z', but we alias 'cd' to it for muscle memory
if type -q zoxide
    alias cd="z"
end

# Ripgrep (better grep)
if type -q rg
    alias grep="rg"
end

# Fd (better find)
if type -q fd
    alias find="fd"
end
if type -q fdfind
    alias fd="fdfind"
    alias find="fdfind"
end

# Safety/Convenience
alias ..="cd .."

# Kubuntu specific: System update
# Matches bash 'apt-update' alias logic
alias update-system="sudo apt update && sudo apt list --upgradable && sudo apt upgrade && sudo apt autoremove"

# VPN Connection
alias eqon-vpn="sudo openfortivpn -c ~/OneDrive/Development/touwolf/eqon-fortivpn.conf"

# ===================================
# ENVIRONMENT VARIABLES
# ===================================
# Set editor to micro, nano, or vim
set -gx EDITOR nano

# ===================================
# DEV TOOLS CONFIGURATION
# ===================================

# Direnv
if type -q direnv
    direnv hook fish | source
end

# Git AskPass
set -gx GIT_ASKPASS /usr/bin/ksshaskpass

# JEnv (Java Version Manager)
set -gx JENV_HOME "$HOME/.jenv"
if test -d "$JENV_HOME"
    fish_add_path "$JENV_HOME/bin"
    if type -q jenv
        jenv init - | source
    end
end

# fnm (Fast Node Manager)
set -gx FNM_HOME "$HOME/.local/share/fnm"
if test -d "$FNM_HOME"
    fish_add_path "$FNM_HOME"
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end
end

# Flutter
set -gx FLUTTER_HOME "$HOME/.local/share/flutter"
if test -d "$FLUTTER_HOME"
    fish_add_path "$FLUTTER_HOME/bin"
    fish_add_path "$HOME/.pub-cache/bin"
end

# Android SDK
set -gx ANDROID_HOME "$HOME/.android-sdk"
if test -d "$ANDROID_HOME"
    set -gx ANDROID_SDK_ROOT "$ANDROID_HOME"
    fish_add_path "$ANDROID_HOME/platform-tools"
    fish_add_path "$ANDROID_HOME/cmdline-tools/latest/bin"
    fish_add_path "$ANDROID_HOME/build-tools/36.0.0"
end
