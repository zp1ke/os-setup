# PowerShell Profile Configuration
# Windows terminal setup with modern CLI tools

# ===================================
# 1. PROMPT CONFIGURATION
# ===================================
# Starship prompt
Invoke-Expression (&starship init powershell)

# Set Starship config location
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"

# ===================================
# 2. INTEGRATIONS
# ===================================
# Zoxide (smarter cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ===================================
# 3. ALIASES & FUNCTIONS
# ===================================

# Eza (better ls)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue

    function ls {
        eza --icons @args
    }

    function ll {
        eza -l --icons --git --group-directories-first @args
    }

    function la {
        eza -la --icons --git --group-directories-first @args
    }
}

# Bat (better cat)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat {
        bat --style=plain @args
    }
}

# Zoxide (better cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Set-Alias -Name cd -Value z -Option AllScope -Scope Global -Force
}

# ===================================
# 4. ADDITIONAL SETTINGS
# ===================================
# PSReadLine configuration for better command-line editing
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
}

# ===================================
# 5. GREETING
# ===================================
# Disable default greeting
$PSStyle.FileInfo.Directory = "`e[34m"
