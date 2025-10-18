# Theme and Wallpaper Setup

## Prerequisites

Install PowerShell 7 from the Microsoft Store.

Check the installed path:
```powershell
Get-Command pwsh.exe -All | Select-Object Source
```

## Configuration

1. Copy the `config` folder to your user directory (e.g., `C:\Users\YourName\`)
2. Edit `Theme-Setup.xml` and update:
   - Path to your config folder
   - Path to `pwsh.exe`
3. Customize `wallpapers.txt` and `theme.txt` with your preferences

## Setup Scheduled Task

1. Open **Task Scheduler**
2. Click **Action** > **Import Task...**
3. Browse to and select `Theme-Setup.xml` from your config folder
4. Verify all script paths are correct and save
