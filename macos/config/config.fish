# Fish Shell Configuration for macOS
# Based on NixOS configuration

# ===================================
# STARSHIP PROMPT
# ===================================
starship init fish | source

# ===================================
# ZOXIDE (Better cd)
# ===================================
zoxide init fish | source

# ===================================
# DISABLE GREETING
# ===================================
set fish_greeting

# ===================================
# ALIASES - Modern CLI Tools
# ===================================

# Eza (better ls)
alias ls="eza --icons"
alias ll="eza -l --icons --git --group-directories-first"
alias la="eza -la --icons --git --group-directories-first"

# Bat (better cat)
# --style=plain is good for 'cat' so you don't get grid lines when copying text
alias cat="bat --style=plain"

# Zoxide (better cd)
# Note: zoxide initializes 'z', but we alias 'cd' to it for muscle memory
alias cd="z"

# Ripgrep (better grep)
alias grep="rg"

# Fd (better find)
alias find="fd"

# Safety/Convenience
alias ..="cd .."

# macOS specific: Homebrew update
alias update-system="brew update && brew upgrade && brew cleanup"

# ===================================
# ENVIRONMENT VARIABLES
# ===================================

# Starship config location
set -x STARSHIP_CONFIG ~/.config/starship.toml

# Editor preferences
set -x EDITOR "code"
set -x VISUAL "code"

# Homebrew
# Make sure homebrew binaries are in PATH
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# ===================================
# OPTIONAL: VI KEY BINDINGS
# ===================================
# Uncomment the following line if you prefer vi key bindings
# fish_vi_key_bindings

# ===================================
# FZF INTEGRATION (if installed)
# ===================================
# FZF key bindings (Ctrl+R for history search, Ctrl+T for file search)
if type -q fzf
    fzf --fish | source
end

# ===================================
# DIRENV INTEGRATION (if installed)
# ===================================
if type -q direnv
    direnv hook fish | source
end
