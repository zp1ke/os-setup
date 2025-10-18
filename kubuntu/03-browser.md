## Install Microsoft Edge

Add repository:
```shell
sudo apt install curl
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo apt update
```

Fix sources (if needed):
- Add `Architectures: amd64` under `Components`
- Add `Signed-By: /etc/apt/trusted.gpg.d/microsoft-edge.gpg`

Install:
```shell
sudo apt install microsoft-edge-stable
```

## Fix sidebar linux issue

Restore the HubApps file from backup:
```shell
cp /path/to/backup/HubApps ~/.config/microsoft-edge/Default/
```
