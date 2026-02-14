# NixOS Configuration

A minimal yet powerful NixOS configuration featuring KDE Plasma 6, Fish shell with modern terminal tools, and essential development utilities. This setup is designed for both Virtual Machines and bare metal (with optional Nvidia support).

## Features

- **Desktop Environment**: KDE Plasma 6 (via SDDM with Wayland).
- **Shell**: Fish shell, configured with modern defaults.
- **Terminal Modernization**:
  - `starship`: Customizable prompt.
  - `eza`: Modern replacement for `ls` with icons.
  - `bat`: Modern replacement for `cat` with syntax highlighting.
  - `zoxide`: Smarter `cd`.
  - `ripgrep`, `fd`, `fzf` for fast searching.
  - **WezTerm**: GPU-accelerated terminal emulator configured via Lua.
- **Bootloader**: GRUB with `distro-grub-themes` support.
- **Software**: Microsoft Edge, VS Code, Btop.
- **Hardware Config**: Includes specific settings for UEFI boot, brightness control, and optional proprietary Nvidia drivers.

## Installation

### 1. Boot Environment
Boot into your NixOS installer image (VM or Physical Hardware).

### 2. Partition & Mount (Fresh Install Only)
**Skip this if you are upgrading an existing system.**

For a standard UEFI system (common in VirtualBox/VMware):

1. **Check Disk Name**:
   ```bash
   lsblk  # Identifies disks (usually 'sda', 'vda', or 'nvme0n1')
   ```

2. **Partition Disk**:
   ```bash
   sudo cfdisk /dev/sda  # Replace 'sda' with your drive
   ```
   - Select **gpt** label type.
   - Create **New** 512M partition -> Type: **EFI System**.
   - Create **New** 4G partition -> Type: **Linux swap**.
   - Create **New** partition (Rest) -> Type: **Linux filesystem**.
   - Select **Write** (type `yes`) -> **Quit**.

3. **Format & Mount**:
   ```bash
   # Format Boot Partition
   sudo mkfs.fat -F 32 /dev/sda1

   # Setup Swap
   sudo mkswap /dev/sda2
   sudo swapon /dev/sda2

   # Format & Mount Root
   sudo mkfs.ext4 /dev/sda3
   sudo mount /dev/sda3 /mnt
   sudo mkdir /mnt/boot
   sudo mount /dev/sda1 /mnt/boot
   ```

### 3. Generate Configuration
Once disks are mounted to `/mnt`:
```bash
sudo nixos-generate-config --root /mnt
```
This generates configuration files in `/mnt/etc/nixos/`. **Do not overwrite `hardware-configuration.nix` with the file from this repo unless you are sure.**

### 4. Apply Configuration
Replace the default `configuration.nix` with the one provided in this directory.

#### Option A: Copy/Paste (If Clipboard Works)
```bash
sudo nano /mnt/etc/nixos/configuration.nix
# Paste the content of configuration.nix here
```
*Note: You also need to create the config directory and files manually if using this method, which is tedious. Consider Option B.*

#### Option B: Transfer via SSH (If Paste Fails)
If VirtualBox/VMware clipboard sharing isn't working:

1. **In the VM**:
   ```bash
   sudo passwd nixos        # Set a temporary password (e.g., "nixos")
   sudo systemctl start sshd # Start the SSH server
   ip addr                  # Note your IP address (e.g., 192.168.x.x)
   ```

   > **Troubleshooting: IP is 10.0.2.15?**
   > This is the default NAT IP and is not reachable from your host.
   >
   > **Fix for VirtualBox:**
   > In the VirtualBox window menu, go to **Devices > Network > Network Settings > Advanced > Port Forwarding**. Add a new rule:
   > - **Protocol**: TCP
   > - **Host Port**: `2222`
   > - **Guest Port**: `22` (Leave IPs blank)
   >
   > **Fix for QEMU/KVM (virt-manager):**
   > 1. Shutdown the VM.
   > 2. In virt-manager, select your VM and click **Open** (or double-click).
   > 3. Click the **Show virtual hardware details** icon (ℹ️ or "i" button).
   > 4. Select **NIC** in the left panel.
   > 5. Change **Network source** from `NAT` to `Bridge device...` or use port forwarding:
   >    - For port forwarding with NAT: Edit the VM's XML directly or use `virsh`:
   >      ```bash
   >      virsh edit <vm-name>
   >      ```
   >      Add under `<devices>`:
   >      ```xml
   >      <qemu:commandline>
   >        <qemu:arg value='-netdev'/>
   >        <qemu:arg value='user,id=net0,hostfwd=tcp::2222-:22'/>
   >      </qemu:commandline>
   >      ```
   >    - Or simply switch to **Bridge** mode for direct network access.
   > 6. Start the VM and check the new IP with `ip addr`.

2. **On your Host Machine**:
   Open a terminal in this project folder and run the command matching your network setup. We need to copy both the config and the scripts folder.

   **If you used Port Forwarding (IP was 10.0.2.15):**
   ```powershell
   scp -P 2222 -r nixos/* nixos@localhost:~/
   ```

   **If using Bridged Adapter (IP is 192.168.x.x):**
   ```powershell
   scp -r nixos/* nixos@<VM_IP>:~/
   ```

3. **In the VM**:
   Move the files to the correct location:
   ```bash
   # Copy configuration file
   sudo cp ~/configuration.nix /mnt/etc/nixos/configuration.nix

   # Copy config folder (contains starship, fish, wezterm configs)
   sudo cp -r ~/config /mnt/etc/nixos/
   ```

### 5. Customization Required
Before applying, open the config and change the following:
```bash
sudo nano /mnt/etc/nixos/configuration.nix
```

- **Username**:
  - The default configuration uses the username `zp1ke`.
  - Press `Ctrl + \` (Replace) in nano.
  - Search for `zp1ke` and replace it with your desired username (e.g., `john`).
  - This updates the user definition and all home directory paths.

- **Nvidia Drivers**:
  - **VM**: Keep Section 4 commented out.
  - **Real Hardware**: Uncomment Section 4 if you have an Nvidia GPU.

### 6. Install or Rebuild
**Choose the correct command for your situation:**

**Option A: Fresh Installation (From Live ISO)**
If you are installing NixOS to your hard drive for the first time:
```bash
sudo nixos-install
```
> **Getting "No space left on device"?**
> You are likely trying to build purely in the Live ISO's RAM. Ensure you have partitioned your disks and mounted them to `/mnt`, and make sure your `configuration.nix` is saved in `/mnt/etc/nixos/` not `/etc/nixos/`.

**Option B: Updating an Existing System**
If you are already running NixOS and just applying changes:
```bash
sudo nixos-rebuild switch
```

### 7. Reboot
```bash
reboot
```

### 8. Post-Install Setup
After rebooting, you might not be able to log in to the graphical session immediately if you haven't set a user password.

1. **Login as Root**:
   - If SDDM (the login screen) doesn't let you login, press `Ctrl + Alt + F2` to switch to a TTY.
   - Login with `root` and the password you set during installation.
   - If you didn't set a root password, generic text-mode installers sometimes leave it blank or `nixos`.

2. **Set User Password**:
   ```bash
   passwd your_username
   ```
   Replace `your_username` with the username you configured in `configuration.nix`.

3. **Return to GUI**:
   - Press `Ctrl + Alt + F1` (or `F7`).
   - Login with your user.

### KDE Theme Presets (Day/Night Cycle)
Copy the Look and Feel presets so KDE Day/Night cycle can find them:
```bash
mkdir -p ~/.local/share/plasma
cp -r kubuntu/config/look-and-feel ~/.local/share/plasma/look-and-feel
```

## Included Aliases

The configuration includes several Fish aliases/abbreviations for convenience:
- `ls`, `ll`, `la` -> Mapped to `eza` (icons, git status, directories first).
- `cat` -> Mapped to `bat` (plain style).
