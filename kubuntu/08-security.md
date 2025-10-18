## Antivirus

Install [ClamAV](https://docs.clamav.net/manual/Installing/Packages.html).
```shell
sudo apt install clamav clamav-daemon
```

Add to *~/.bash_aliases*:
```bash
av-scan() {
  clamscan --infected -r "${1:-/}"
}
```