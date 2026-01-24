{
  description = "A Flutter development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
          };
        };

        flutter = pkgs.flutter;

        # ---------------------------------------------------------------------
        # ANDROID SDK CONFIGURATION
        # Adjust versions if you need different platforms or build tools.
        # ---------------------------------------------------------------------
        androidPackages = pkgs.androidenv.composeAndroidPackages {
          platformVersions = [ "36" ];
          buildToolsVersions = [ "36.0.0" ];
          platformToolsVersion = "36.0.2";
          includeEmulator = false;
          includeSystemImages = false;
        };

        androidSdk = androidPackages.androidsdk;

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            flutter
            androidSdk
          ];

          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          FLUTTER_ROOT = "${flutter}";

          shellHook = ''
            export PATH="${flutter}/bin:${flutter}/bin/cache/dart-sdk/bin:$PATH"
            export PATH="${androidSdk}/libexec/android-sdk/platform-tools:$PATH"
            echo "🦋 Flutter Development Environment Loaded!"
            echo " - Flutter: $(flutter --version | head -n 1)"
            echo " - Android SDK: $ANDROID_SDK_ROOT"
          '';
        };
      }
    );
}
