## Install drivers

```shell
sudo ubuntu-drivers autoinstall
```

## Adjust local time for dual boot

```shell
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl
```

## File Manager - Krusader

Krusader is a powerful dual-pane file manager, ideal for advanced file operations and users who prefer a more feature-rich alternative to Dolphin.

### Install Krusader

```bash
sudo apt update
sudo apt install krusader

# Install recommended tools for full functionality
sudo apt install kdiff3 krename

# Optional: Email client integration (if you use KMail)
# sudo apt install kmail
```

**Recommended tools:**
- **kdiff3**: Diff and merge utility for comparing files and directories
- **krename**: Advanced batch renaming tool
- **kmail**: Email client (optional, for email integration)

### Set as Default File Manager (Optional)

If you want to replace Dolphin completely:

```bash
# Set Krusader as the default file manager in KDE settings
kwriteconfig6 --file kdeglobals --group General --key BrowserApplication krusader.desktop

# Manually edit the MIME associations file:
mkdir -p ~/.config
cat >> ~/.config/mimeapps.list << 'EOF'

[Added Associations]
inode/directory=krusader.desktop;

[Default Applications]
inode/directory=krusader.desktop;
EOF
```

After changing, log out and log back in for full effect.

### Key Features

- **Dual-pane interface**: Navigate two directories simultaneously
- **Built-in archive handling**: Create and extract archives without external tools
- **Advanced search**: Powerful search and filter capabilities
- **Batch rename**: Rename multiple files with patterns
- **Root mode**: Open as root when needed with `krusader --su`
- **Synchronizer**: Compare and sync directories
- **Custom commands**: Add your own commands and scripts

### Configure WezTerm Integration

To make Krusader use WezTerm instead of Konsole:

1. **Set External Terminal**:
   - Open Krusader → Settings → Configure Krusader
   - Go to General → Terminal
   - Set external terminal to: `wezterm`

2. **Update Terminal Execution for User Actions**:
   - Go to Settings → Configure Krusader → User Actions
   - In the "Terminal execution" field, replace:

   ```
   konsole --noclose --workdir %d --title %t -e
   ```

   with:

   ```
   wezterm start --cwd %d --
   ```

### Tips

- Use `F3` to view files and `F4` to edit them
- `Ctrl+\` swaps panels
- Tab switches between panels
- Configure custom keyboard shortcuts in Settings → Configure Shortcuts