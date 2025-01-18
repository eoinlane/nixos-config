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
  #nixpkgs.overlays = [ (import /etc/nixos/overlays/cava.nix) ];

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

  #  services.xrdp.defaultWindowManager = "gnome-remote-desktop";

  programs.nix-ld.enable = true;

  services.tailscale.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    package = pkgs.docker_25;
  };

  virtualisation.podman.enable = true;

  # Allow unfree packages

  # Hardware configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # NVIDIA driver configuration
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.nvidia-container-toolkit.enable = true;
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
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ hplipWithPlugin ];
    };
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
      "docker"
    ]; # Enable sudo for the user.
    packages = with pkgs; [ tree ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.allowed-users = [ "*" ];

  # System packages
  environment.systemPackages = with pkgs; [
    docker-compose
    ntfs3g
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
    go
    gnumake
    nvidia-container-toolkit
    podman
    vlc
    gnome-remote-desktop
  ];

  # https://nixos.wiki/wiki/Remote_Desktop
  services.xrdp = {
    enable = true;
    openFirewall = true;

    defaultWindowManager = "gnome-session";
  };
  ##services.gnome-remote-desktop.enable = true; # (would not want to work without this)
  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  fileSystems."/mnt/media" = {
    device = "//raspberrypi/MyMedia";
    fsType = "cifs";
    options = [
      "username=eoin"
      "password=el"
      "rw"
      "uid=1000"
      "gid=100"
      "x-systemd.automount"
      "noauto"
    ];
  };
  # Enable OpenSSH
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  # System state version
  system.stateVersion = "24.05"; # Initial NixOS version installed.

  users.users.root.initialHashedPassword = ""; # Set root password.
}
