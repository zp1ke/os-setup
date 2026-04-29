# Nanobot Setup on Ubuntu Mini Server

This document describes the local Nanobot setup using:

- Nanobot
- `llama3.2:1b`
- Nanobot OpenAI-compatible API server
- Nanobot gateway
- systemd services
- UFW LAN-only access rules

Ollama installation and model setup are documented in `ubuntu-server/08-ollama.md`.

---

## Installation Context

Nanobot is installed and running through:

- `uv`
- Python virtual environment
- User-level config file

Use `ubuntu-server/config/nanobot.config.json` in this repo as the reference guide when creating the user Nanobot configuration file:

```text
~/.nanobot/config.json
```

One simple way to start from the repo template is:

```bash
mkdir -p ~/.nanobot
cp ubuntu-server/config/nanobot.config.json ~/.nanobot/config.json
```

The Nanobot config points its OpenAI-compatible provider to Ollama:

```text
http://localhost:11434/v1
```

The active model is:

```text
llama3.2:1b
```

The working configuration was tested with:

```bash
nanobot agent -m "Hi"
```

Expected result:

```text
🐈 nanobot
Hello! How can I help you today?
```

A backup of the working config should be kept:

```bash
cp ~/.nanobot/config.json ~/.nanobot/config.working.json
```

---

## Network Configuration

Nanobot uses two services:

| Component | Command | Port |
|---|---:|---:|
| API server | `nanobot serve` | `8900` |
| Gateway | `nanobot gateway` | `18790` |

The Nanobot config file should expose both the API and gateway on the LAN.

Use `ubuntu-server/config/nanobot.config.json` as the reference guide for the values in:

```text
~/.nanobot/config.json
```

Do not expose Nanobot directly to the public internet.

---

## Firewall Rules

UFW is enabled.

Nanobot access is restricted to the local subnet:

```text
192.168.100.0/24
```

Required UFW rules:

```bash
sudo ufw allow from 192.168.100.0/24 to any port 8900 proto tcp
sudo ufw allow from 192.168.100.0/24 to any port 18790 proto tcp
```

Check firewall status:

```bash
sudo ufw status numbered
```

Expected relevant rules:

```text
8900/tcp   ALLOW IN    192.168.100.0/24
18790/tcp  ALLOW IN    192.168.100.0/24
```

SSH was also available through UFW. For better security, SSH can optionally be restricted to the LAN subnet too.

---

## Manually Start Nanobot

Start the Nanobot API server:

```bash
nanobot serve
```

Start the Nanobot gateway in another terminal:

```bash
nanobot gateway
```

Verify listening ports:

```bash
ss -tulpn | grep -E '8900|18790'
```

Expected result should include:

```text
0.0.0.0:8900
0.0.0.0:18790
```

or equivalent wildcard bindings.

---

## Test Nanobot API Locally

From the server:

```bash
curl http://127.0.0.1:8900/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer anything" \
  -d '{
    "model": "llama3.2:1b",
    "messages": [
      {
        "role": "user",
        "content": "Reply only with: Nanobot API works"
      }
    ],
    "stream": false
  }'
```

---

## Test Nanobot API from LAN

From another device on the same network:

```bash
curl http://192.168.100.20:8900/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer anything" \
  -d '{
    "model": "llama3.2:1b",
    "messages": [
      {
        "role": "user",
        "content": "Reply only with: LAN works"
      }
    ],
    "stream": false
  }'
```

If this returns a model response, Nanobot is reachable over the LAN.

---

## Create systemd Services

Nanobot should run persistently using two systemd services:

- `nanobot-serve.service`
- `nanobot-gateway.service`

First, find the actual Nanobot executable path:

```bash
readlink -f "$(which nanobot)"
```

Use that path in both systemd unit files.

Recommended unit file locations:

```text
/etc/systemd/system/nanobot-serve.service
/etc/systemd/system/nanobot-gateway.service
```

Create the API service:

```bash
sudo nano /etc/systemd/system/nanobot-serve.service
```

Create the gateway service:

```bash
sudo nano /etc/systemd/system/nanobot-gateway.service
```

The API service should run:

```bash
nanobot serve
```

The gateway service should run:

```bash
nanobot gateway
```

Both services should run as user:

```text
zp1ke
```

Both services should use:

```text
/home/zp1ke
```

as the working directory and home environment.

---

## Enable and Start Services

Reload systemd:

```bash
sudo systemctl daemon-reload
```

Enable and start Nanobot API:

```bash
sudo systemctl enable --now nanobot-serve.service
```

Enable and start Nanobot gateway:

```bash
sudo systemctl enable --now nanobot-gateway.service
```

Check service status:

```bash
systemctl status nanobot-serve.service --no-pager
systemctl status nanobot-gateway.service --no-pager
```

Check listening ports:

```bash
ss -tulpn | grep -E '8900|18790'
```

---

## Logs and Troubleshooting

View Nanobot API logs:

```bash
journalctl -u nanobot-serve.service -n 100 --no-pager
```

View Nanobot gateway logs:

```bash
journalctl -u nanobot-gateway.service -n 100 --no-pager
```

Follow logs live:

```bash
journalctl -u nanobot-serve.service -f
```

```bash
journalctl -u nanobot-gateway.service -f
```

Restart services:

```bash
sudo systemctl restart nanobot-serve.service
sudo systemctl restart nanobot-gateway.service
```

---

## Useful Commands

Check Nanobot status:

```bash
nanobot status
```

Check Nanobot help:

```bash
nanobot --help
```

Check ports:

```bash
ss -tulpn | grep -E '8900|18790'
```

Check firewall:

```bash
sudo ufw status numbered
```

---

## Uninstall Nanobot

Use this section to remove Nanobot while keeping Ollama available.

Stop and disable Nanobot services:

```bash
sudo systemctl disable --now nanobot-gateway.service
sudo systemctl disable --now nanobot-serve.service
```

Remove Nanobot service unit files:

```bash
sudo rm -f /etc/systemd/system/nanobot-serve.service
sudo rm -f /etc/systemd/system/nanobot-gateway.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

Remove UFW rules for Nanobot ports:

```bash
sudo ufw status numbered
sudo ufw delete <rule-number>
sudo ufw status numbered
```

Delete rules for `8900/tcp` and `18790/tcp` from `192.168.100.0/24`.

If Nanobot was installed with `uv tool`:

```bash
uv tool uninstall nanobot
```

If Nanobot was installed in a virtual environment, remove the environment directory.

Optional backup:

```bash
cp -a ~/.nanobot ~/.nanobot.backup.$(date +%F)
```

Remove Nanobot config/cache data:

```bash
rm -rf ~/.nanobot
```

Verify Nanobot is no longer active:

```bash
systemctl status nanobot-serve.service --no-pager
systemctl status nanobot-gateway.service --no-pager
ss -tulpn | grep -E '8900|18790'
```

Expected result: no Nanobot listeners.

To remove Ollama too, follow uninstall steps in `ubuntu-server/08-ollama.md`.

---

## Security Notes

Nanobot is exposed only to the local network.

Current LAN access:

```text
192.168.100.0/24
```

Important security reminders:

- Do not expose ports `8900` or `18790` to the public internet.
- Keep UFW enabled.
- Keep Nanobot restricted to the local subnet.
- Be careful with Nanobot shell execution features.
- If Nanobot command execution is enabled, any client with access to Nanobot may be able to trigger server-side commands.
- Consider disabling Nanobot exec tools unless server automation is intentionally needed.

---

## Current Working Stack

Final working setup:

```text
Client device on LAN
        ↓
http://192.168.100.20:8900
        ↓
Nanobot API server
        ↓
Nanobot provider config
        ↓
Ollama OpenAI-compatible API
        ↓
llama3.2:1b
```

Services:

```text
ollama.service
nanobot-serve.service
nanobot-gateway.service
```

Main config file:

```text
~/.nanobot/config.json
```

Reference guide in this repo:

```text
ubuntu-server/config/nanobot.config.json
```

Main model:

```text
llama3.2:1b
```
