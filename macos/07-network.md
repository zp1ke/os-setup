# Network - macOS

This guide covers OpenFortiVPN setup on macOS.

## OpenFortiVPN

Install:
```shell
brew install openfortivpn
```

Ensure *~/.local/bin* is in Fish PATH:
```bash
fish_add_path ~/.local/bin
```

Create launcher script in *~/.local/bin* to use configuration from *PATH_TO_fortivpn.conf*:
```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/forti-vpn <<'EOF'
#!/usr/bin/env bash
sudo openfortivpn -c PATH_TO_fortivpn.conf
EOF
chmod +x ~/.local/bin/forti-vpn
```
