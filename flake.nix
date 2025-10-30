{
  description = "NixOS config for Kayros";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, /* hyprland, */ ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.kayros-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit /* hyprland */; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kayros = import ./home.nix;
          }
        ];
      };
    };
}