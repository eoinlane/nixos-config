{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hosts
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.allowed-users = [ "*" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  networking.hostName = "nixos-olan";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Dublin";

  programs.nix-ld.enable = true;
  programs.virt-manager.enable = true;

  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "gnome-session";
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  users.groups.libvirtd.members = [ "olan" ];

  users.users.olan = {
    isNormalUser = true;
    home = "/home/olan";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "vboxusers"
    ];
    packages = with pkgs; [ tree ];
  };

  users.users.root.initialHashedPassword = "";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };
    nvidia-container-toolkit.enable = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    xkb = {
      layout = "us";
      options = "eurosign:e,caps:escape";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      linuxHeaders
      ntfs3g
      firefox
      git
      tmux
      eza
      htop
      vim
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
    variables = {
      NIXOS_OZONE_WL = "1";
      PATH = [
        "/home/olan/.local/bin"
        "/home/olan/.config/rofi/scripts"
      ];
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  fileSystems."/home/olan/media" = {
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.05";
}
