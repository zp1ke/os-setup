{
  description = "A Node.js/TypeScript development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # ---------------------------------------------------------------------
        # NODE VERSION CONFIGURATION
        # Change `nodejs-22_x` to `nodejs-20_x` or `nodejs-18_x` to switch versions.
        # ---------------------------------------------------------------------
        nodeVersion = pkgs.nodejs_22;

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodeVersion

            # Package Managers (Corepack includes yarn/pnpm, but we can add them explicitly if preferred)
            corepack

            # Essential Tools
            typescript
            typescript-language-server
          ];

          shellHook = ''
            echo "🌱 Node.js Development Environment Loaded!"
            echo " - Node Version: $(node --version)"
            echo " - Npm Version: $(npm --version)"
          '';
        };
      }
    );
}
