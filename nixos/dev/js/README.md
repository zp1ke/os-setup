# Node.js/TypeScript Development Environment (Nix Flake)

This folder contains a reproducible development environment for JavaScript/TypeScript using Nix Flakes.

## Prerequisites

- **Nix** with Flakes enabled.

## Usage

### 1. Enter the Environment

```bash
cd nixos/dev/js
nix develop
```

This will load **Node.js 22**, **Corepack** (for Yarn/PNPM), and **TypeScript**.

### 2. VS Code Integration

This template includes pre-configured VS Code settings.

1.  Open this folder: `code .`
2.  **Extensions**: Install the recommended extensions (ESLint, Prettier).
3.  **Corepack**: If you use Yarn or PNPM, you can activate them via Corepack in the terminal:
    ```bash
    corepack enable
    ```

### 3. Change Node Version

To switch versions:
1.  Open `flake.nix`.
2.  Change `pkgs.nodejs_22` to `pkgs.nodejs_20` or `pkgs.nodejs_18`.
3.  Reload the shell (`nix develop`).
