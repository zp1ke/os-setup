# Theme and Wallpaper Setup

## Prerequisites

Install PowerShell 7 from the Microsoft Store.

## Configuration

1. Copy the `config` folder to your user directory (e.g., `C:\Users\YourName\config\`)
2. Edit `Theme-Setup.xml`:
   - Update `<Author>` with your computer and username
   - Update `<UserId>` with your SID (run `whoami /user` in PowerShell)
   - Update `<WorkingDirectory>` paths to your config folder
   - Update `<Command>` paths to your `pwsh.exe` location (find with `Get-Command pwsh.exe | Select-Object Source`)
3. Customize `wallpapers.txt` and `theme.txt` with your preferences

## Import Scheduled Task

1. Open **Task Scheduler**
2. Click **Action** > **Import Task...**
3. Browse to and select `Theme-Setup.xml`
4. Verify all paths and save
