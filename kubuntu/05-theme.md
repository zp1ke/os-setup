## Customize Grub

Follow the [guide](https://k1ng.dev/distro-grub-themes/installation#manual-installation).

### Remember last Grub choice

```
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```

### Update Grub:

```shell
sudo update-grub
```

## Bibata Cursors

Download from the cursors settings (System Settings -> Colors & Themes -> Cursors -> Get New... -> Bibata Modern Amber), then select and apply.

## Dynamic theme

Copy service files:
```shell
cp ./theme/theme-setup.service ~/.config/systemd/user/
cp ./theme/theme-setup.timer ~/.config/systemd/user/
```

Create *~/.config/theme-by-time.conf* with start time (HHMM format) and theme name per line:

Check available themes:
```shell
lookandfeeltool --list
```

Example configuration:
```config
0600 org.kde.breeze.desktop
1800 org.kde.breezedark.desktop
```

Enable and start:
```shell
systemctl --user daemon-reload
systemctl --user enable --now theme-setup.timer
systemctl --user enable theme-setup.service
systemctl --user list-timers
```

Disable and stop:
```shell
# Disable the timer first (otherwise systemd may warn that the service's triggering unit is still active)
systemctl --user disable --now theme-setup.timer
systemctl --user disable theme-setup.service

# Optional: if it ran recently, stop any in-flight run
systemctl --user stop theme-setup.service

systemctl --user daemon-reload
systemctl --user list-timers | grep theme-setup || true
```

Optional cleanup (remove unit files):
```shell
rm -f ~/.config/systemd/user/theme-setup.timer ~/.config/systemd/user/theme-setup.service
systemctl --user daemon-reload
```

Check logs:
```shell
journalctl --user -u theme-setup.service
```

## Dynamic wallpaper

Copy service files:
```shell
cp ./theme/wallpaper-setup.service ~/.config/systemd/user/
cp ./theme/wallpaper-setup.timer ~/.config/systemd/user/
```

Create *~/.config/wallpaper-by-time.conf* with start time (HHMM format) and wallpaper path per line.

Example configuration:
```config
0100 PATH_TO_BitDay/12-Late-Night.png
0600 PATH_TO_BitDay/01-Early-Morning.png
0700 PATH_TO_BitDay/02-Mid-Morning.png
0900 PATH_TO_BitDay/03-Late-Morning.png
1100 PATH_TO_BitDay/04-Early-Afternoon.png
1200 PATH_TO_BitDay/05-Mid-Afternoon.png
1400 PATH_TO_BitDay/06-Late-Afternoon.png
1700 PATH_TO_BitDay/07-Early-Evening.png
1800 PATH_TO_BitDay/08-Mid-Evening.png
1900 PATH_TO_BitDay/09-Late-Evening.png
2000 PATH_TO_BitDay/10-Early-Night.png
2300 PATH_TO_BitDay/11-Mid-Night.png
```

Enable and start:
```shell
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-setup.timer
systemctl --user enable wallpaper-setup.service
systemctl --user list-timers
```

Disable and stop:
```shell
# Disable the timer first (otherwise systemd may warn that the service's triggering unit is still active)
systemctl --user disable --now wallpaper-setup.timer
systemctl --user disable wallpaper-setup.service

# Optional: if it ran recently, stop any in-flight run
systemctl --user stop wallpaper-setup.service

systemctl --user daemon-reload
systemctl --user list-timers | grep wallpaper-setup || true
```

Optional cleanup (remove unit files):
```shell
rm -f ~/.config/systemd/user/wallpaper-setup.timer ~/.config/systemd/user/wallpaper-setup.service
systemctl --user daemon-reload
```

Check logs:
```shell
journalctl --user -u wallpaper-setup.service
```
