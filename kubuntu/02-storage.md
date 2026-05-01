# Install rclone (shared)

Use one tool for both OneDrive and Google Drive.

```shell
sudo apt update && sudo apt install rclone
```

# OneDrive

## Azure app setup (recommended)

Using your own Azure app credentials for OneDrive can improve reliability by avoiding shared default credentials.

Verify these are complete:

1. Open [Microsoft Entra admin center](https://entra.microsoft.com) (or [Azure Portal](https://portal.azure.com)).
2. Go to Microsoft Entra ID > App registrations > New registration:
	- Name: for example, Rclone-OneDrive
	- Supported account types: Accounts in any organizational directory and personal Microsoft accounts
	- Redirect URI (Public client/native): http://localhost
3. Open your app registration and copy the Application (client) ID.
4. Open Certificates & secrets > New client secret:
	- Create a secret and copy its Value immediately
5. Open API permissions and ensure Microsoft Graph delegated permissions for OneDrive are present.

Use these credentials in rclone step 4 below.

## Configure rclone remote

```shell
rclone config
```

Use these answers:

1. n (New remote)
2. Name: onedrive
3. Storage: onedrive (Microsoft OneDrive)
4. Client ID / Client Secret: paste your Azure app Client ID and Secret (or leave blank to use rclone defaults)
5. Region: choose your region (usually global)
6. Edit advanced config: n
7. Use auto config: y
8. Sign in with Microsoft and approve access
9. Choose drive type (personal/business)
10. Confirm: y, then q to quit

## Test mount in Kubuntu

```shell
mkdir -p ~/OneDrive
rclone mount onedrive: ~/OneDrive --vfs-cache-mode full &
```

Open Dolphin and verify files are visible in ~/OneDrive.

## Auto-mount on login (systemd user service)

Create ~/.config/systemd/user/rclone-onedrive.service with:

```ini
[Unit]
Description=Rclone OneDrive Mount
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount onedrive: %h/OneDrive \
	--vfs-cache-mode full \
	--vfs-cache-max-age 24h \
	--vfs-cache-max-size 10G
ExecStop=/bin/fusermount -u %h/OneDrive
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

Enable and start:

```shell
systemctl --user daemon-reload
systemctl --user enable rclone-onedrive.service
systemctl --user start rclone-onedrive.service
systemctl --user status rclone-onedrive.service
```

# Google Drive

Use your own Google OAuth Client ID/Secret for better reliability and speed.

Rclone is already installed in the shared setup section above.

## Google Cloud setup

Verify these are complete:

1. Open [Google Cloud Console](https://console.cloud.google.com).
2. In your project, enable the Google Drive API.
3. Open APIs & Services > OAuth consent screen:
	- User type: External
	- App name and support/developer email set
	- Add your own Gmail address in Test users
4. Open APIs & Services > Credentials:
	- OAuth client ID type: Desktop app
	- Copy Client ID and Client Secret

## Configure rclone

```shell
rclone config
```

Use these answers:

1. n (New remote)
2. Name: gdrive
3. Storage: drive (Google Drive)
4. Client ID: paste your Client ID
5. Client Secret: paste your Client Secret
6. Scope: 1 (Full access)
7. Service account file: leave blank
8. Edit advanced config: n
9. Use auto config: y
10. Sign in via browser and allow access (if warning appears, choose Advanced and continue)
11. Shared drive: n (unless you use one)
12. Confirm: y, then q to quit

## Test mount in Kubuntu

Create a local mount directory:

```shell
mkdir -p ~/GoogleDrive
```

Mount manually:

```shell
rclone mount gdrive: ~/GoogleDrive --vfs-cache-mode full &
```

Open Dolphin and verify files are visible in ~/GoogleDrive.

## Auto-mount on login (systemd user service)

Create the user systemd directory:

```shell
mkdir -p ~/.config/systemd/user
```

Create ~/.config/systemd/user/rclone-gdrive.service with:

```ini
[Unit]
Description=Rclone Google Drive Mount
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount gdrive: %h/GoogleDrive \
	 --vfs-cache-mode full \
	 --vfs-cache-max-age 24h \
	 --vfs-cache-max-size 10G
ExecStop=/bin/fusermount -u %h/GoogleDrive
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

Enable and start:

```shell
systemctl --user daemon-reload
systemctl --user enable rclone-gdrive.service
systemctl --user start rclone-gdrive.service
systemctl --user status rclone-gdrive.service
```

## Safety tips

1. Verification after large syncs:

```shell
rclone check gdrive: ~/GoogleDrive
```

2. Permissions: rclone only accesses what you authorized in OAuth.
3. Optional encryption: create an rclone crypt remote later for encrypted uploads.

## Sync workflow (not mount)

If you prefer local copies over live mounts, use `rclone sync`.

Sample scripts are available in this repo:

1. `kubuntu/scripts/rclone-sync-in.sh`
2. `kubuntu/scripts/rclone-sync-out.sh`

Recommended local directory:

```shell
mkdir -p ~/XDrive
```

Example pull from cloud to local (`sync-in`):

```shell
rclone sync xdrive: ~/XDrive --progress
```

Example push local to cloud (`sync-out`):

```shell
rclone sync ~/XDrive xdrive: --progress
```

Notes:

1. `sync` makes destination match source, including deletions.
2. For a safer first run, add `--dry-run`.
3. To protect against accidental deletes, add `--backup-dir ~/XDrive-backups/$(date +%F)` when syncing out.
