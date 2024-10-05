{
  inputs,
  system,
  lib,
  config,
  pkgs,
  hyprland,
  nixvim,
  ...
}:

{

  imports = [
    hyprland.homeManagerModules.default
    #./environment
    ./programs
    ./scripts
    ./themes
  ];

  # Define the username and home directory path
  home = {
    username = "olan";
    homeDirectory = "/home/olan";
  };

  # Install packages to the user's profile
  home.packages =
    (with pkgs; [
      dunst
      cava
      rofi
      kitty
      hyprpaper
      networkmanagerapplet
      # CLI tools
      neofetch # System information tool
      nnn # Terminal file manager
      ripgrep # Recursively searches directories for a regex pattern
      gedit
      jq # Command-line JSON processor
      yq-go # Command-line YAML processor
      eza # Modern replacement for 'ls'
      fzf # Fuzzy finder

      # Archive tools
      zip # Zip utility
      xz # Compression tool
      unzip # Unzip utility
      p7zip # 7z archive manager

      # Networking tools
      mtr # Network diagnostic tool
      iperf3 # Network bandwidth testing
      dnsutils # Provides 'dig' and 'nslookup'
      ldns # 'drill', an alternative to 'dig'
      aria2 # Lightweight multi-protocol download utility
      socat # Replacement for 'netcat'
      nmap # Network discovery and security auditing tool
      ipcalc # IP address calculator

      # System utilities
      cowsay # Fun ASCII art generator
      file # Determines file type
      which # Locates a command
      tree # Displays directory trees
      gnused # GNU 'sed' stream edito:wr
      gnutar # GNU 'tar' archiving utility
      gawk # Pattern scanning and processing language
      zstd # Compression tool
      gnupg # GNU Privacy Guard for encryption
      pcmanfm # Lightweight file manager
      dropbox # Dropbox client for file syncing

      # Nix-related tools
      nix-output-monitor # Enhanced Nix command output with more details

      # Productivity tools
      hugo # Static site generator
      glow # Markdown viewer in terminal

      # Monitoring tools
      btop # Resource monitor, replacement for 'htop'
      iotop # Monitor disk I/O usage
      iftop # Network traffic monitoring

      # Debugging tools
      strace # Trace system calls
      ltrace # Trace library calls
      lsof # List open files

      # System tools
      sysstat # Performance monitoring
      lm_sensors # Hardware monitoring (for temperature, etc.)
      ethtool # Network interface configuration
      pciutils # Tools for PCI devices (e.g., `lspci`)
      usbutils # Tools for USB devices (e.g., `lsusb`)
      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # JetBrains Mono font with NerdFont icons

      # Add nixvim as a package for Neovim management
      inputs.nixvim.packages.${pkgs.system}.default
    ])
    ++ (with pkgs.gnome; [
      nautilus
      zenity
      gnome-tweaks
      eog
    ]);

  # Enable fontconfig for managing fonts
  fonts.fontconfig.enable = true;

  # Basic git configuration (customize to your own details)
  programs.git = {
    enable = true;
    userName = "Eoin Lane"; # Your git username
    userEmail = "eoinlane@gmail.com"; # Your git email
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # Home Manager state version for backward compatibility
  home.stateVersion = "23.11";

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;
}
