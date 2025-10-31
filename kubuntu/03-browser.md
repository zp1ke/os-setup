# Browser Setup

## Microsoft Edge

### Add Repository

```bash
sudo apt install curl
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo apt update
sudo apt modernize-sources
```

### Fix Repository Sources

Edit `/etc/apt/sources.list.d/microsoft-edge-dev.sources`:

```
Architectures: amd64
Signed-By: /etc/apt/trusted.gpg.d/microsoft-edge.gpg
```

### Install

```bash
sudo apt install microsoft-edge-stable
```

### Fix Sidebar Issue

Restore HubApps from backup:

```bash
cp /path/to/backup/HubApps ~/.config/microsoft-edge/Default/
```
