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
2.  **Extensions**: You will see a popup recommending extensions. Install them (Java Pack).
3.  **Java Detection**: The `.vscode/settings.json` is configured to use the `JAVA_HOME` provided by Nix.

If VS Code complains it cannot find Java or Maven, ensure the environment is active by running `nix develop` in the terminal.

### 3. IntelliJ Settings Persistence

This flake pins IntelliJ settings to a stable directory so your login and preferences do not reset when Nix updates the IDE version.
To avoid IDE build failures, IntelliJ is included only in the optional `.#idea` shell.

You can switch the IntelliJ package by editing the `ideaPkg` variable in the flake (e.g., `pkgs.jetbrains.idea` or `pkgs.jetbrains.idea-oss`).

- IntelliJ config root: `~/.config/idea-nix-config`
- The shell exports `IDEA_PROPERTIES` to point at a stable `idea.properties` file.

If you want to reset IntelliJ completely, delete `~/.config/idea-nix-config`.

### 4. Tooling Caches

The dev shell uses standard cache locations to keep builds fast across sessions:

- Gradle: `~/.cache/gradle`
- Maven: `~/.m2`

### 5. Switching Java Versions

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
5. Reload the shell (`nix develop`).
