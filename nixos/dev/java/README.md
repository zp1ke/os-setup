# Java Development Environment (Nix Flake)

This folder contains a reproducible development environment for Java using Nix Flakes.

## Prerequisites

- **Nix** with Flakes enabled.
- **Direnv** (optional but recommended) to automatically load the environment.

## Usage

### 1. Enter the Environment

**With direnv (Recommended):**
Just `cd` into this directory and run:
```bash
direnv allow
```

**Without direnv:**
Run manually:
```bash
nix develop
```

### 2. VS Code Integration

To get the best experience in VS Code, this template includes a `.vscode` folder with pre-built settings.

1.  Open this folder in VS Code: `code .`
2.  **Extensions**: You will see a popup recommending extensions. Install them (Java Pack & direnv).
3.  **Setup**: The `direnv` extension should automatically allow the environment. If not, run `Direnv: Allow` from the command palette.
4.  **Java Detection**: The `.vscode/settings.json` is configured to use the `JAVA_HOME` provided by Nix.

If VS Code complains it cannot find Java or Maven, ensure the `direnv` extension is active and has allowed the env.

### 3. IntelliJ Settings Persistence

This flake pins IntelliJ settings to a stable directory so your login and preferences do not reset when Nix updates the IDE version.

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
5. Direnv will reload automatically (or run `nix develop` again).
