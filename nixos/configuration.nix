{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- 1. BOOTLOADER ---
  # For modern UEFI Systems (Standard for most VMs now)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3; # Limit boot entries to the last 3
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

    # KDE Tools (Required for theme scripts)
    kdePackages.qttools # For qdbus6
    kdePackages.kconfig # For kwriteconfig6
  ];

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
    cat > /home/zp1ke/.config/starship.toml <<EOF
    # Tokyo Night inspired palette (Dynamic)
    palette = "tokyo_night"

    [palettes.tokyo_night]
    red = "#f7768e"
    orange = "#ff9e64"
    yellow = "#e0af68"
    green = "#9ece6a"
    blue = "#7aa2f7"
    purple = "#bb9af7"
    cyan = "#7dcfff"
    white = "#a9b1d6"
    bg = "#1a1b26"

    [palettes.tokyo_day]
    red = "#f52a65"
    orange = "#b15c00"
    yellow = "#8c6c3c"
    green = "#587539"
    blue = "#385fbf"
    purple = "#7847bd"
    cyan = "#007197"
    white = "#3760bf"
    bg = "#e1e2e7"

    [character]
    success_symbol = "[➜](bold green)"
    error_symbol = "[➜](bold red)"
    EOF

    chown zp1ke:users /home/zp1ke/.config/starship.toml
  '';

  # --- 9. FISH CONFIGURATION ---
  programs.fish = {
    enable = true;

    # The Aliases: Map old commands to new cool tools
    shellAliases = {
      # Eza (better ls)
      ls  = "eza --icons";                                     # Just 'ls' now shows icons
      ll  = "eza -l --icons --git --group-directories-first";  # detailed list
      la  = "eza -la --icons --git --group-directories-first"; # all files

      # Bat (better cat)
      # --style=plain is good for 'cat' so you don't get grid lines when copying text
      cat = "bat --style=plain";

      # Zoxide (better cd)
      # Note: zoxide initializes 'z', but we can alias 'cd' to it for muscle memory
      cd = "z";

      # Ripgrep (better grep)
      grep = "rg";

      # Fd (better find)
      find = "fd";

      # Safety/Convenience
      ".." = "cd ..";
      # Rebuild, keep current + 2 older generations, and free space
      update-system = "sudo nixos-rebuild switch && sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && sudo nix-collect-garbage";
    };

    # Initialize integrations
    interactiveShellInit = ''
      # Zoxide integration
      ${pkgs.zoxide}/bin/zoxide init fish | source

      # Starship prompt
      set -x STARSHIP_CONFIG /home/zp1ke/.config/starship.toml

      # Disable greeting message
      set fish_greeting

      # Enable vi key bindings (optional - comment out if you prefer default emacs mode)
      # fish_vi_key_bindings
    '';
  };

  # Enable Docker daemon (for later use)
  virtualisation.docker.enable = true;

  # --- 10. SYSTEM AUTOMATION ---
  # Create Fish config file with direnv hook
  system.activationScripts.setupFishConfig = ''
    ${pkgs.coreutils}/bin/mkdir -p /home/zp1ke/.config/fish
    ${pkgs.coreutils}/bin/chown zp1ke:users /home/zp1ke/.config

    if [ ! -f /home/zp1ke/.config/fish/config.fish ]; then
      echo 'direnv hook fish | source' > /home/zp1ke/.config/fish/config.fish
    fi

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

  # --- 12. AUTOMATED TASK: AUTO KONSOLE THEME ---
  systemd.user.services.auto-konsole-theme = {
    description = "Auto-switch Konsole theme based on system color scheme";
    serviceConfig.Type = "oneshot";
    # Ensure the script can find these commands
    path = with pkgs; [
      bash
      gnugrep
      kdePackages.qttools # for qdbus6
      kdePackages.kconfig # for kwriteconfig6
    ];
    script = builtins.readFile ./scripts/auto-konsole-theme.sh;
  };

  systemd.user.timers.auto-konsole-theme = {
    wantedBy = [ "timers.target" ];
    partOf = [ "auto-konsole-theme.service" ];
    timerConfig = {
      OnCalendar = "*:0/15"; # Run every 15 minutes
      OnStartupSec = "1s";   # Run immediately after login
      Unit = "auto-konsole-theme.service";
    };
  };

  # --- 13. GENERATE KONSOLE PROFILES ---
  system.activationScripts.setupKonsoleProfiles = ''
    mkdir -p /home/zp1ke/.local/share/konsole
    ${pkgs.coreutils}/bin/chown zp1ke:users /home/zp1ke/.local
    ${pkgs.coreutils}/bin/chown zp1ke:users /home/zp1ke/.local/share

    # Write Dark Profile
    cat > /home/zp1ke/.local/share/konsole/Dark.profile <<EOF
    ${builtins.readFile ./config/konsole/Dark.profile}
    EOF

    # Write Light Profile
    cat > /home/zp1ke/.local/share/konsole/Light.profile <<EOF
    ${builtins.readFile ./config/konsole/Light.profile}
    EOF

    # Write Color Schemes
    cat > /home/zp1ke/.local/share/konsole/TokyoNight.colorscheme <<EOF
    ${builtins.readFile ./config/konsole/TokyoNight.colorscheme}
    EOF

    cat > /home/zp1ke/.local/share/konsole/TokyoDay.colorscheme <<EOF
    ${builtins.readFile ./config/konsole/TokyoDay.colorscheme}
    EOF

    # Fix permissions
    ${pkgs.coreutils}/bin/chown -R zp1ke:users /home/zp1ke/.local/share/konsole
  '';}
