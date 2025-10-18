## Install client

Follow the [installation guide](https://software.opensuse.org/download.html?project=home:npreining:debian-ubuntu-onedrive&package=onedrive#manualUbuntu).

## Initial sync

```shell
onedrive --sync
```

## Enable and start service

```shell
systemctl enable --user onedrive
systemctl start --user onedrive
systemctl status --user onedrive
```