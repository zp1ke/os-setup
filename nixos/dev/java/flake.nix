{
  description = "A Java development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # ---------------------------------------------------------------------
        # JAVA VERSION CONFIGURATION
        # Change `jdk17` to `jdk8` or `jdk21` to switch versions.
        # ---------------------------------------------------------------------
        jdk = pkgs.jdk17;

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            jdk
            maven
            gradle

            # Application/Formatters
            google-java-format
            jdt-language-server

            # IDEs
            jetbrains.idea-oss
          ];

          # Environment variables
          JAVA_HOME = "${jdk}";

          shellHook = ''
            # Setup stable IntelliJ configuration directory
            # This prevents configuration resets when the package version changes
            IDEA_CONFIG_DIR="$HOME/.config/idea-nix-config"
            mkdir -p "$IDEA_CONFIG_DIR"
            if [ ! -f "$IDEA_CONFIG_DIR/idea.properties" ]; then
              cat > "$IDEA_CONFIG_DIR/idea.properties" <<EOF
            idea.config.path=$IDEA_CONFIG_DIR/config
            idea.system.path=$IDEA_CONFIG_DIR/system
            idea.plugins.path=$IDEA_CONFIG_DIR/plugins
            idea.log.path=$IDEA_CONFIG_DIR/log
            EOF
            fi
            export IDEA_PROPERTIES="$IDEA_CONFIG_DIR/idea.properties"

            # Tooling caches
            export GRADLE_USER_HOME="$HOME/.cache/gradle"
            export MAVEN_USER_HOME="$HOME/.m2"

            echo "☕ Java Development Environment Loaded!"
            echo "Java Version: $(java -version 2>&1 | head -n 1)"
            echo "Maven Version: $(mvn -version | head -n 1)"
            echo "Gradle Version: $(gradle -version | head -n 1)"
          '';
        };
      }
    );
}
