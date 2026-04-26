# PowerShell Profile Configuration
# Windows terminal setup with modern CLI tools

# ===================================
# 1. PROMPT CONFIGURATION
# ===================================
# Starship prompt (requires PowerShell 7+)
if ($PSVersionTable.PSVersion.Major -ge 7) {
    # Set config location before init so Starship reads the right file
    $ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
    # Disable VS Code's built-in shell integration; Starship handles it natively
    $ENV:VSCODE_SHELL_INTEGRATION = "0"
    Invoke-Expression (&starship init powershell)
} else {
    Write-Host "⚠️  Starship requires PowerShell 7+. You are using PowerShell $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
    Write-Host "   Install with: winget install Microsoft.PowerShell"
}

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
    Set-PSReadLineOption -Colors @{
        InlinePrediction    = "`e[38;5;244m"
        ListPrediction      = "`e[38;5;244m"
        ListPredictionSelected = "`e[38;5;235;48;5;250m"
    }
}

# ===================================
# 5. GREETING
# ===================================
# Disable default greeting
$PSStyle.FileInfo.Directory = "`e[34m"

# Mise (runtime manager)
if (Get-Command mise -ErrorAction SilentlyContinue) {
    (&mise activate pwsh) | Out-String | Invoke-Expression
}
