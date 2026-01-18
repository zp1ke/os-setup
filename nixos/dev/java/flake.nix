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
          buildInputs = with pkgs; [
            jdk
            maven
            gradle

            # Application/Formatters
            google-java-format
            jdt-language-server
          ];

          # Environment variables
          JAVA_HOME = "${jdk}";

          shellHook = ''
            echo "☕ Java Development Environment Loaded"
            echo "Java Version: $(java -version 2>&1 | head -n 1)"
            echo "Maven Version: $(mvn -version | head -n 1)"
            echo "Gradle Version: $(gradle -version | head -n 1)"
          '';
        };
      }
    );
}
