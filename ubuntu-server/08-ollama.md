# Ollama Setup on Ubuntu Mini Server

This document describes installing, testing, and removing Ollama for local model hosting.

Model used in this setup:

- `llama3.2:1b`

---

## Install Ollama

Install Ollama:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Enable and start the Ollama service:

```bash
sudo systemctl enable --now ollama
```

Check Ollama service status:

```bash
systemctl status ollama
```

---

## Install a Lightweight Model

Pull the model:

```bash
ollama pull llama3.2:1b
```

Test the model interactively:

```bash
ollama run llama3.2:1b
```

Exit the interactive session with:

```text
/bye
```

---

## Test Ollama API

Test Ollama native API:

```bash
curl http://localhost:11434/api/generate \
  -d '{
    "model": "llama3.2:1b",
    "prompt": "Say hello in one short sentence.",
    "stream": false
  }'
```

Test Ollama OpenAI-compatible API:

```bash
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ollama" \
  -d '{
    "model": "llama3.2:1b",
    "messages": [
      {
        "role": "user",
        "content": "Say hello in one short sentence."
      }
    ]
  }'
```

If both commands return valid responses, Ollama is working correctly.

---

## GitHub Copilot (Plugin and CLI)

This section shows how to use GitHub Copilot tools on Ubuntu and how to use Ollama with a Copilot-style local CLI flow.

### VS Code Plugin

Install GitHub Copilot and GitHub Copilot Chat extensions in VS Code, then sign in to your GitHub account.

Important limitation:

- GitHub Copilot extension does not support replacing Copilot cloud models with a local Ollama endpoint.
- Ollama models like `llama3.2:1b` cannot be selected as a native Copilot model in the extension.

Practical local alternative in VS Code:

- Use an extension that supports OpenAI-compatible endpoints.
- Point it to `http://localhost:11434/v1`.
- Set model to `llama3.2:1b`.

### GitHub CLI (`gh`) Copilot

Install the Copilot CLI extension:

```bash
gh extension install github/gh-copilot
```

Typical usage:

```bash
gh copilot suggest -t shell "find large files in current directory"
gh copilot explain "sudo find / -name '*.log'"
```

Important limitation:

- `gh copilot` does not currently support custom model endpoints.
- You cannot directly switch `gh copilot` to Ollama.

### Local Ollama CLI Helper (Copilot-Style)

If you want a local command-line assistant backed by Ollama, add this helper to your shell config.

Fish shell function (`~/.config/fish/config.fish`):

```fish
function gho
    set -l prompt (string join " " $argv)
    curl -s http://127.0.0.1:11434/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ollama" \
      -d "{\"model\":\"llama3.2:1b\",\"messages\":[{\"role\":\"user\",\"content\":\"$prompt\"}],\"stream\":false}" \
      | jq -r '.choices[0].message.content'
end
```

Example:

```bash
gho "write a safe rsync command to back up /etc to /tmp/etc-backup"
```

---

## Useful Commands

Check available Ollama models:

```bash
ollama list
```

Check Ollama service status:

```bash
systemctl status ollama
```

Check Ollama listening port:

```bash
ss -tulpn | grep 11434
```

---

## Uninstall Ollama

Stop and disable Ollama:

```bash
sudo systemctl disable --now ollama
```

Remove Ollama package/binaries using the official uninstall script:

```bash
curl -fsSL https://ollama.com/install.sh | sh -s -- --uninstall
```

Remove Ollama model and state data:

```bash
rm -rf ~/.ollama
sudo rm -rf /usr/share/ollama
```

Verify Ollama is no longer active:

```bash
systemctl status ollama --no-pager
ss -tulpn | grep 11434
```

Expected result: no active `ollama` service and no listener on port `11434`.
