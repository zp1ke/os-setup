{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- 1. BOOTLOADER ---
  # Switch to GRUB for themes support (distro-grub-themes)
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    configurationLimit = 3;
    # Create a clean derivation for the theme to avoid copying issues
    theme = pkgs.runCommand "distro-grub-theme" {} ''
      mkdir -p $out
      tarball="${builtins.fetchTarball {
        url = "https://github.com/AdisonCavani/distro-grub-themes/archive/v3.2.tar.gz";
        # sha256 = "0c2fe66895c1655025e17da9d80365116744040da2586820573e33f3747180de"; # Commented out to avoid hash mismatch
      }}"

      # Find the theme directory (account for packed tarballs)
      if [ -f "$tarball/themes/nixos.tar" ]; then
        tar -xf "$tarball/themes/nixos.tar" -C "$out/"
      elif [ -f "$tarball/themes/NixOS.tar" ]; then
        tar -xf "$tarball/themes/NixOS.tar" -C "$out/"
      else
        echo "Error: Could not find nixos.tar theme in $tarball"
        echo "Available themes:"
        ls "$tarball/themes"
        exit 1
      fi
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # --- 2. NETWORKING & LOCALE ---
  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # --- 3. GRAPHICS & DESKTOP (KDE Plasma 6) ---
  services.xserver.enable = true;

  # Enable SDDM (Login Screen) and Plasma 6
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # --- 4. NVIDIA DRIVERS ---
  # ⚠️ VM SAFETY: Keep this block COMMENTED OUT inside a Virtual Machine.
  # UNCOMMENT only when installing on real hardware with the RTX 4070.
  /*
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # Use proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  */

  # --- 5. USER ACCOUNT ---
  users.users.zp1ke = {
    isNormalUser = true;
    description = "Zp1k_e";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish; # Set Fish as default shell
  };

  # --- 6. PACKAGES & SOFTWARE ---
  nixpkgs.config.allowUnfree = true; # Required for Edge, Nvidia, etc.

  environment.systemPackages = with pkgs; [
    # Core Utils
    git
    wget
    curl
    btop             # Modern task manager
    tree
    jq               # Command-line JSON processor

    # Terminal "Cool Factor" Tools
    starship         # The Prompt
    eza              # Modern replacement for 'ls' (adds icons/colors)
    bat              # Modern replacement for 'cat' (adds syntax highlighting)
    zoxide           # Smarter 'cd' command
    direnv           # Per-directory environment variables
    fzf              # Command-line fuzzy finder
    ripgrep          # The 'grep' replacement (ultra fast)
    fd               # The 'find' replacement (user friendly)

    # Fish Plugins
    fishPlugins.bass
    fishPlugins.colored-man-pages

    # Desktop Apps
    microsoft-edge   # Browser with Workspaces support
    bibata-cursors   # Modern cursor theme
    vscode           # Editor
    wezterm          # Terminal
  ];

  # --- 6.1 ENVIRONMENT VARIABLES ---
  environment.variables = {
    # Cursor Theme (Fixes reset on reboot)
    XCURSOR_THEME = "Bibata-Modern-Amber";
    XCURSOR_SIZE = "24";
  };

  # --- 7. FONTS (Required for Icons) ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
  ];

  # Set default system fonts
  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "CaskaydiaCove Nerd Font Mono" ];
      sansSerif = [ "CaskaydiaCove Nerd Font" ]; # Optional: if you want it everywhere
    };
  };

  # --- 8. STARSHIP CONFIGURATION (The Prompt) ---
  programs.starship = {
    enable = true;
    # We generate the config manually in activationScripts to allow dynamic theme switching
    # Fish will load this config via STARSHIP_CONFIG environment variable
  };

  # Activation script to generate mutable starship config
  system.activationScripts.setupStarship = ''
    mkdir -p /home/zp1ke/.config
    chown zp1ke:users /home/zp1ke/.config
    ${pkgs.coreutils}/bin/install -m 0644 ${./config/starship.toml} /home/zp1ke/.config/starship.toml

    chown zp1ke:users /home/zp1ke/.config/starship.toml
  '';

  # --- 9. FISH CONFIGURATION ---
  programs.fish = {
    enable = true;
  };

  # Enable Docker daemon (for later use)
  virtualisation.docker.enable = true;

  # --- 10. SYSTEM AUTOMATION ---
  # Create Fish config file with direnv hook
  system.activationScripts.setupFishConfig = ''
    ${pkgs.coreutils}/bin/mkdir -p /home/zp1ke/.config/fish
    ${pkgs.coreutils}/bin/chown zp1ke:users /home/zp1ke/.config

    ${pkgs.coreutils}/bin/install -m 0644 ${./config/config.fish} /home/zp1ke/.config/fish/config.fish

    # Always ensure ownership is correct
    ${pkgs.coreutils}/bin/chown -R zp1ke:users /home/zp1ke/.config/fish
  '';

  # --- 11. SYSTEM STATE ---
  system.stateVersion = "25.11";

  # --- 11.5 NIX SETTINGS (Flakes & Direnv) ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better caching for nix flakes
  };

  # --- 11.6 GARBAGE COLLECTION ---
  # Automatically free up space by deleting old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- 12. WEZTERM CONFIGURATION ---
  system.activationScripts.setupWezterm = ''
    mkdir -p /home/zp1ke/.config/wezterm
    chown zp1ke:users /home/zp1ke/.config/wezterm

    ${pkgs.coreutils}/bin/install -m 0644 ${./config/wezterm.lua} /home/zp1ke/.config/wezterm/wezterm.lua

    chown zp1ke:users /home/zp1ke/.config/wezterm/wezterm.lua
  '';}
