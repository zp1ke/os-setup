[CmdletBinding()]
param(
    [string]$ConfigFile,
    [switch]$Force,          # Re-apply even if already correct
    [switch]$DryRun,
    [switch]$AppsOnly,       # Override config: affect only Apps theme
    [switch]$SystemOnly      # Override config: affect only System (taskbar, system surfaces)
)

<#
Config format (default file: theme.txt in same folder):
- Each non-blank, non-comment line:
  TIME MODE [SCOPE]
  TIME  = HHmm or HH (24h). 7 -> 0700, 930 -> 0930, etc.
  MODE  = light | dark (case-insensitive; can also use 1 / 0 / on / off where on=light, off=dark)
  SCOPE = apps | system | both   (optional; default = both)
Examples:
0700 light both
1830 dark
23   dark system
# 06:30 just apps light
0630 light apps
#>

function Write-Log {
    param([string]$Message,[string]$Level="INFO")
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Write-Verbose "[$ts][$Level] $Message"
}

# Resolve default config
if (-not $ConfigFile) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $ConfigFile = Join-Path $scriptDir 'theme.txt'
}
if (-not (Test-Path $ConfigFile)) {
    Write-Error "Theme config file not found: $ConfigFile"
    exit 1
}

$raw = Get-Content -Path $ConfigFile -ErrorAction Stop

$entries = foreach ($line in $raw) {
    $t = $line.Trim()
    if (-not $t) { continue }
    if ($t -match '^\s*[#;]') { continue }

    # Split into at most 3 tokens: time, mode, scope(optional)
    $parts = $t -split '\s+',3
    if ($parts.Count -lt 2) {
        Write-Log "Skipping malformed line: $line" "WARN"
        continue
    }
    $timeToken = $parts[0]
    $modeToken = $parts[1]
    $scopeToken = if ($parts.Count -ge 3) { $parts[2] } else { "both" }

    # Normalize time
    if ($timeToken -match '^\d{1,2}$') {
        $timeToken = "{0:00}00" -f [int]$timeToken
    } elseif ($timeToken -match '^\d{3}$') {
        $timeToken = $timeToken.PadLeft(4,'0')
    } elseif ($timeToken -notmatch '^\d{4}$') {
        Write-Log "Invalid time token '$timeToken' in line: $line" "WARN"
        continue
    }
    $hh = [int]$timeToken.Substring(0,2)
    $mm = [int]$timeToken.Substring(2,2)
    if ($hh -gt 23 -or $mm -gt 59) {
        Write-Log "Out-of-range time '$timeToken' in line: $line" "WARN"
        continue
    }

    # Normalize mode
    $modeNorm = $modeToken.ToLower()
    switch -Regex ($modeNorm) {
        '^(light|1|on|day)$' { $modeNorm = 'light' }
        '^(dark|0|off|night)$' { $modeNorm = 'dark' }
        default {
            Write-Log "Invalid mode '$modeToken' in line: $line" "WARN"
            continue
        }
    }

    $scopeNorm = ($scopeToken ?? "both").ToLower()
    switch ($scopeNorm) {
        'apps' { }
        'system' { }
        'both' { }
        default {
            Write-Log "Invalid scope '$scopeToken' in line: $line (use apps|system|both)" "WARN"
            continue
        }
    }

    [pscustomobject]@{
        TimeHHmm = $timeToken
        Minutes  = $hh*60 + $mm
        Mode     = $modeNorm
        Scope    = $scopeNorm
    }
}

if (-not $entries) {
    Write-Error "No valid theme schedule entries."
    exit 2
}

# Sort ascending by time
$entries = $entries | Sort-Object Minutes

# Current time
$now = Get-Date
$currMinutes = $now.Hour*60 + $now.Minute

# Pick last entry <= now, else wrap to last
$selected = ($entries | Where-Object { $_.Minutes -le $currMinutes } | Select-Object -Last 1)
if (-not $selected) {
    $selected = $entries | Select-Object -Last 1
}

# Override scopes if command line narrowing
$effectiveScope = $selected.Scope
if ($AppsOnly -and $SystemOnly) {
    Write-Error "Cannot specify both -AppsOnly and -SystemOnly."
    exit 3
} elseif ($AppsOnly) {
    $effectiveScope = 'apps'
} elseif ($SystemOnly) {
    $effectiveScope = 'system'
}

$desiredMode = $selected.Mode  # light or dark

Write-Log "Selected slot $($selected.TimeHHmm): mode=$desiredMode scope=$effectiveScope" "INFO"

# Registry paths & values
$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

$lightValue = if ($desiredMode -eq 'light') { 1 } else { 0 }

# Determine current values
$currentApps   = (Get-ItemProperty -Path $regPath -Name AppsUseLightTheme -ErrorAction SilentlyContinue)?.AppsUseLightTheme
$currentSystem = (Get-ItemProperty -Path $regPath -Name SystemUsesLightTheme -ErrorAction SilentlyContinue)?.SystemUsesLightTheme

$willChange = $false

if ($effectiveScope -in @('apps','both')) {
    if ($Force -or ($currentApps -ne $lightValue)) {
        Write-Log "Setting AppsUseLightTheme = $lightValue" "INFO"
        if (-not $DryRun) {
            Set-ItemProperty -Path $regPath -Name AppsUseLightTheme -Value $lightValue -Type DWord
        }
        $willChange = $true
    } else {
        Write-Log "Apps theme already $desiredMode" "INFO"
    }
}

if ($effectiveScope -in @('system','both')) {
    if ($Force -or ($currentSystem -ne $lightValue)) {
        Write-Log "Setting SystemUsesLightTheme = $lightValue" "INFO"
        if (-not $DryRun) {
            Set-ItemProperty -Path $regPath -Name SystemUsesLightTheme -Value $lightValue -Type DWord
        }
        $willChange = $true
    } else {
        Write-Log "System theme already $desiredMode" "INFO"
    }
}

if (-not $willChange -and -not $Force) {
    Write-Log "No theme change needed." "INFO"
    exit 0
}

if ($DryRun) {
    Write-Log "DryRun: Skipping broadcast/theme refresh."
    exit 0
}

# Broadcast change so shell & apps update faster
$code = @"
using System;
using System.Runtime.InteropServices;
public static class ThemeBroadcast {
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, int fuFlags, int uTimeout, out IntPtr lpdwResult);
}
"@
if (-not ([System.Management.Automation.PSTypeName]'ThemeBroadcast').Type) {
    Add-Type -TypeDefinition $code -ErrorAction Stop
}

$HWND_BROADCAST   = [IntPtr]0xFFFF
$WM_SETTINGCHANGE = 0x1A
$SMTO_ABORTIFHUNG = 0x0002
$timeoutMs = 5000

# Broadcast both general personalize change and immersive color set
[IntPtr]$result = [IntPtr]::Zero
[ThemeBroadcast]::SendMessageTimeout($HWND_BROADCAST,$WM_SETTINGCHANGE,[IntPtr]::Zero,"ImmersiveColorSet",$SMTO_ABORTIFHUNG,$timeoutMs,[ref]$result) | Out-Null
[ThemeBroadcast]::SendMessageTimeout($HWND_BROADCAST,$WM_SETTINGCHANGE,[IntPtr]::Zero,"WindowsPersonalize",$SMTO_ABORTIFHUNG,$timeoutMs,[ref]$result) | Out-Null

Write-Log "Theme mode applied: $desiredMode (scope=$effectiveScope)" "INFO"
exit 0