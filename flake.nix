{
  description = "Eoin's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:eoinlane/nixvim";
    hyprland.url = "github:hyprwm/Hyprland";
    #hyprland.url = "git+https://github.com/hyprwm/hyprland?submodules=1";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    ghostty.url = "github:ghostty-org/ghostty";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      hyprland,
      vscode-server,
      ghostty,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;

    in
    {
      nixosConfigurations = {
        nixos-olan = lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit hyprland inputs;
          };
          modules = [
            vscode-server.nixosModules.default
            ./configuration.nix
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.olan = import ./home/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
              services.vscode-server.enable = true;
            }
          ];
        };
      };
    };
}
