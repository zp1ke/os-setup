[CmdletBinding()]
param(
    [string]$ConfigFile,
    [switch]$Force,          # Force re-apply even if same as last
    [switch]$NoConvert,      # Skip BMP conversion (Windows usually handles PNG/JPG; keep true if you see issues)
    [switch]$DryRun,
    [ValidateSet("Fill", "Fit", "Stretch", "Tile", "Center", "Span")]
    [string]$Style = "Fill"  # Wallpaper display style
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Write-Verbose "[$ts][$Level] $Message"
}

# Resolve config file
if (-not $ConfigFile) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $ConfigFile = Join-Path $scriptDir 'wallpapers.txt'
}
if (-not (Test-Path $ConfigFile)) {
    Write-Error "Config file not found: $ConfigFile"
    exit 1
}

# Read & parse
$rawLines = Get-Content -Path $ConfigFile -ErrorAction Stop
$entries = foreach ($line in $rawLines) {
    $trim = $line.Trim()
    if (-not $trim) { continue }
    if ($trim -match '^\s*[#;]') { continue }
    # Split first token (time) remainder (path)
    if ($trim -match '^\s*(\S+)\s+(.+)$') {
        $timeToken = $matches[1]
        $pathToken = $matches[2].Trim('"')
        # Normalize time
        if ($timeToken -match '^\d{1,2}$') {
            $timeToken = "{0:00}00" -f [int]$timeToken
        }
        elseif ($timeToken -match '^\d{3}$') {
            # e.g. 700 => 0700
            $timeToken = $timeToken.PadLeft(4,'0')
        }
        elseif ($timeToken -notmatch '^\d{4}$') {
            Write-Log "Skipping invalid time token '$timeToken'" "WARN"
            continue
        }
        $hh = [int]$timeToken.Substring(0,2)
        $mm = [int]$timeToken.Substring(2,2)
        if ($hh -gt 23 -or $mm -gt 59) {
            Write-Log "Skipping out-of-range time '$timeToken'" "WARN"
            continue
        }
        [pscustomobject]@{
            TimeHHmm = $timeToken
            Minutes  = $hh * 60 + $mm
            PathSpec = $pathToken
        }
    }
    else {
        Write-Log "Skipping unparsable line: $line" "WARN"
    }
}

if (-not $entries) {
    Write-Error "No valid entries in config."
    exit 1
}

# Sort by Minutes
$entries = $entries | Sort-Object Minutes

# Determine now
$now = Get-Date
$currentMinutes = $now.Hour * 60 + $now.Minute

# Select best match (last <= now, else wrap to last)
$selected = ($entries | Where-Object { $_.Minutes -le $currentMinutes } | Select-Object -Last 1)
if (-not $selected) {
    $selected = $entries | Select-Object -Last 1
}

# Resolve actual path
# If relative, base on config file directory
$configDir = Split-Path -Parent (Resolve-Path $ConfigFile)
$wallpaperPath = $selected.PathSpec
if (-not (Test-Path $wallpaperPath)) {
    $candidate = Join-Path $configDir $wallpaperPath
    if (Test-Path $candidate) { $wallpaperPath = $candidate }
}

if (-not (Test-Path $wallpaperPath)) {
    Write-Error "Selected wallpaper not found: $wallpaperPath"
    exit 2
}

# Track state: avoid repeat
$stateDir = Join-Path $env:LOCALAPPDATA "WallpaperScheduler"
if (-not (Test-Path $stateDir)) { New-Item -ItemType Directory -Path $stateDir | Out-Null }
$stateFile = Join-Path $stateDir "last_applied.txt"

$alreadyApplied = $false
if (Test-Path $stateFile) {
    $last = Get-Content $stateFile -TotalCount 1
    if ($last -and (Split-Path $last -Leaf) -eq (Split-Path $wallpaperPath -Leaf)) {
        $alreadyApplied = $true
    }
}

if ($alreadyApplied -and -not $Force) {
    Write-Log "Wallpaper already applied ($wallpaperPath). Skipping." "INFO"
    exit 0
}

# Optional conversion to BMP (improves reliability if some formats fail)
$finalPath = $wallpaperPath
if (-not $NoConvert) {
    $ext = [IO.Path]::GetExtension($wallpaperPath).ToLowerInvariant()
    if ($ext -ne ".bmp") {
        try {
            Add-Type -AssemblyName System.Drawing -ErrorAction Stop
            $bmpTarget = Join-Path $stateDir "current.bmp"
            [System.Drawing.Image]::FromFile($wallpaperPath).Save($bmpTarget, [System.Drawing.Imaging.ImageFormat]::Bmp)
            $finalPath = $bmpTarget
            Write-Log "Converted $wallpaperPath to BMP $bmpTarget" "INFO"
        }
        catch {
            Write-Log "Conversion failed ($($_.Exception.Message)). Will try original file." "WARN"
            $finalPath = $wallpaperPath
        }
    }
}

if ($DryRun) {
    Write-Log "DryRun: Would set wallpaper to $finalPath (selected time $($selected.TimeHHmm))."
    exit 0
}

# Set wallpaper style based on parameter
# Style mappings for Windows registry values:
# Fill: WallpaperStyle="10", TileWallpaper="0" - stretches to fill screen, may crop
# Fit: WallpaperStyle="6", TileWallpaper="0" - fits entire image, may have black bars
# Stretch: WallpaperStyle="2", TileWallpaper="0" - stretches image (may distort)
# Tile: WallpaperStyle="0", TileWallpaper="1" - tiles image
# Center: WallpaperStyle="0", TileWallpaper="0" - centers image
# Span: WallpaperStyle="22", TileWallpaper="0" - spans across multiple monitors

switch ($Style) {
    "Fill" { $wallpaperStyle = "10"; $tileWallpaper = "0" }
    "Fit" { $wallpaperStyle = "6"; $tileWallpaper = "0" }
    "Stretch" { $wallpaperStyle = "2"; $tileWallpaper = "0" }
    "Tile" { $wallpaperStyle = "0"; $tileWallpaper = "1" }
    "Center" { $wallpaperStyle = "0"; $tileWallpaper = "0" }
    "Span" { $wallpaperStyle = "22"; $tileWallpaper = "0" }
}

# Set registry values for wallpaper display style
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value $wallpaperStyle -Type String -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value $tileWallpaper -Type String -ErrorAction Stop
    Write-Log "Set wallpaper style to $Style mode (WallpaperStyle=$wallpaperStyle, TileWallpaper=$tileWallpaper)" "INFO"
}
catch {
    Write-Log "Warning: Could not set wallpaper style registry values: $($_.Exception.Message)" "WARN"
}

# Add pinvoke for SystemParametersInfo
$code = @"
using System;
using System.Runtime.InteropServices;
public class NativeWallpaper {
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
    public static extern bool SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
if (-not ([System.Management.Automation.PSTypeName]'NativeWallpaper').Type) {
    Add-Type -TypeDefinition $code -ErrorAction Stop
}

$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE   = 0x01
$SPIF_SENDCHANGE      = 0x02

$absFinal = (Resolve-Path $finalPath).Path
$result = [NativeWallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $absFinal, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

if (-not $result) {
    $err = [ComponentModel.Win32Exception][Runtime.InteropServices.Marshal]::GetLastWin32Error()
    Write-Error "Failed to set wallpaper: $($err.Message)"
    exit 3
}

$absOriginal = (Resolve-Path $wallpaperPath).Path
$absOriginal | Out-File -FilePath $stateFile -Encoding UTF8 -Force

Write-Log "Wallpaper applied: $absOriginal (effective file: $absFinal) time slot $($selected.TimeHHmm)" "INFO"
exit 0