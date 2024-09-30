{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include hardware scan results.
    ./hosts
    # input.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname configuration
  networking.hostName = "nixos-olan";

  # Networking setup
  networking.networkmanager.enable = true; # Easiest and default for most distros.

  # Time zone configuration
  time.timeZone = "Europe/Dublin";

  # Allow unfree packages

  # Hardware configuration
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  # NVIDIA driver configuration
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # X11 and GNOME configuration
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    xkb.layout = "us";
    xkb.options = "eurosign:e,caps:escape";
  };

  # Sound configuration
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Environment variables and paths
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    PATH = [
      "/home/olan/.local/bin"
      "/home/olan/.config/rofi/scripts"
    ];
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # User configuration
  users.users.olan = {
    isNormalUser = true;
    home = "/home/olan";
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable sudo for the user.
    packages = with pkgs; [ tree ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.allowed-users = [ "*" ];

  # System packages
  environment.systemPackages = with pkgs; [
    firefox
    git
    tmux
    eza
    htop
    vim # Text editor for configuration edits
    wget
    pulseaudio
    sl
    bat
    vscode
    xclip
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    nixfmt-rfc-style
    libevdev
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable OpenSSH
  services.openssh.enable = true;

  # System state version
  system.stateVersion = "24.05"; # Initial NixOS version installed.

  users.users.root.initialHashedPassword = ""; # Set root password.
}
