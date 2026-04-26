# Network and SSH - Ubuntu Server

This guide configures a static IP address and SSH access using private/public keys only.

## 1. Set Static IP (Netplan)

Identify your network interface name:

```shell
ip -br a
```

Create or edit a Netplan file:

```shell
sudo nano /etc/netplan/01-static-ip.yaml
```

You can also copy the repo template and then edit values:

```shell
sudo install -m 600 ubuntu-server/config/01-static-ip.yaml /etc/netplan/01-static-ip.yaml
sudo nano /etc/netplan/01-static-ip.yaml
```

Use this template (replace values):

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: false
      addresses:
        - 192.168.100.20/24
      routes:
        - to: default
          via: 192.168.100.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

Apply and verify:

```shell
sudo chmod 600 /etc/netplan/01-static-ip.yaml
sudo netplan generate
sudo netplan apply
ip a
ip route
```

## 2. Enable SSH Key Authentication

Install and enable OpenSSH server:

```shell
sudo apt update
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```

From your client machine, copy your public key to the server user:

```shell
ssh-copy-id USER@192.168.100.20
```

If needed, do it manually on the server:

```shell
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## 3. Disable Password Login (Key-Only SSH)

Edit SSH daemon config:

```shell
sudo nano /etc/ssh/sshd_config
```

Ensure these settings are present:

```conf
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
PermitRootLogin no
```

Or copy the repo drop-in config:

```shell
sudo mkdir -p /etc/ssh/sshd_config.d
sudo cp ubuntu-server/config/99-key-only.conf /etc/ssh/sshd_config.d/99-key-only.conf
```

Validate and restart SSH:

```shell
sudo sshd -t
sudo systemctl restart ssh
```

## 4. Firewall Rule (Optional but Recommended)

```shell
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

## 5. Verification

From client:

```shell
ssh USER@192.168.100.20
```

Confirm password login is blocked:

```shell
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no USER@192.168.100.20
```

The second command should fail with `Permission denied` when key-only access is correctly enforced.
