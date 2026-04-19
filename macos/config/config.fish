# Fish Shell Configuration
# Shared template across Kubuntu/macOS/NixOS

# ===================================
# 1. INIT
# ===================================
set fish_greeting
set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"

# ===================================
# 2. INTEGRATIONS
# ===================================
if type -q starship
    starship init fish | source
end

if type -q mise
    mise activate fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# ===================================
# 3. ALIASES
# ===================================

# Eza (better ls)
if type -q eza
    alias ls="eza --icons"
    alias ll="eza -l --icons --git --group-directories-first"
    alias la="eza -la --icons --git --group-directories-first"
end

# Bat (better cat)
if type -q bat
    alias cat="bat --style=plain"
else if type -q batcat
    alias bat="batcat"
    alias cat="batcat --style=plain"
end

# Zoxide (better cd)
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
else if type -q fdfind
    alias find="fdfind"
end

# Navigation
alias ..="cd .."

# System update
alias update-system="brew update && brew upgrade && brew cleanup"

# ===================================
# 4. ENVIRONMENT
# ===================================
set -gx EDITOR "code"
set -gx VISUAL "code"

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# ===================================
# OPTIONAL: VI KEY BINDINGS
# ===================================
# fish_vi_key_bindings

# ===================================
# FZF INTEGRATION (if installed)
# ===================================
if type -q fzf
    fzf --fish | source
end
