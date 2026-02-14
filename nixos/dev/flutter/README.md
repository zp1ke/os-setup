# Flutter Development Environment (Nix Flake)

This folder contains a reproducible development environment for Flutter using Nix Flakes.

## Prerequisites

- **Nix** with Flakes enabled.

## Usage

### 1. Enter the Environment

```bash
cd nixos/dev/flutter
nix develop
```

This will load **Flutter** and the **Android SDK** (no Android Studio).

### 2. VS Code Integration

This template includes pre-configured VS Code settings.

1. Open this folder: `code .`
2. Install the recommended extensions (Flutter, Dart).
3. The settings map Flutter and Android SDK paths from the Nix environment.

### 3. Android SDK Notes

- The SDK is provisioned with platform and build tools via Nix.
- Licenses are accepted via the Nix config flag `android_sdk.accept_license = true;` in the flake.
- `ANDROID_SDK_ROOT` and `ANDROID_HOME` are exported in the dev shell.

### 4. Adjusting SDK Versions

To change SDK versions:
1. Open `flake.nix`.
2. Edit the `platformVersions`, `buildToolsVersions`, or `platformToolsVersion` entries.
3. Reload the shell (`nix develop`).
