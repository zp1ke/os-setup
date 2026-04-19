# Java Development Environment (Nix Flake)

This folder contains a reproducible development environment for Java using Nix Flakes.

## Prerequisites

- **Nix** with Flakes enabled.

## Usage

### 1. Enter the Environment

Run manually:
```bash
cd nixos/dev/java
nix develop
```

**With IntelliJ included (optional):**
```bash
nix develop .#idea
```

### 2. VS Code Integration

To get the best experience in VS Code, this template includes a `.vscode` folder with pre-built settings.

1.  Open this folder in VS Code: `code .`
2.  **Extensions**: You will see a popup recommending extensions. Install them.
3.  **Java Detection**: The `.vscode/settings.json` is configured to use the `JAVA_HOME` provided by Nix.

If VS Code complains it cannot find Java or Maven, enter the environment with `nix develop` and launch VS Code from that shell.

### 3. Switching Java Versions

To switch between Java 8, 17, or 21:

1. Open `flake.nix`.
2. Locate the configuration section:
   ```nix
   # ---------------------------------------------------------------------
   # JAVA VERSION CONFIGURATION
   # Change `jdk17` to `jdk8` or `jdk21` to switch versions.
   # ---------------------------------------------------------------------
   jdk = pkgs.jdk17;
   ```
3. Change `pkgs.jdk17` to `pkgs.jdk8` or `pkgs.jdk21`.
4. Save the file.
5. Re-enter the shell with `nix develop`.
