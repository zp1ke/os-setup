# Fish Shell Configuration for Kubuntu
# Matches NixOS/macOS structure

# ===================================
# 1. INIT
# ===================================
# Disable greeting
set fish_greeting

# Initialize Starship
if type -q starship
    starship init fish | source
end

# Initialize Zoxide
if type -q zoxide
    zoxide init fish | source
end

# ===================================
# 2. ALIASES
# ===================================

# Eza (better ls)
if type -q eza
    alias ls="eza --icons"
    alias ll="eza -l --icons --git --group-directories-first"
    alias la="eza -la --icons --git --group-directories-first"
end

# Bat (better cat)
if type -q batcat
    alias bat="batcat"
end
alias cat="bat --style=plain"

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
elseif type -q fdfind
    alias find="fdfind"
end

# Navigation
alias ..="cd .."

# System Update
alias update-system="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"

# ===================================
# 3. ENVIRONMENT
# ===================================
