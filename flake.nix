{
  description = "Minimal Hyprland NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # This will be your hostname - change it to match your system
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Import the hardware configuration (you'll need to generate this)
          ./hardware-configuration.nix
          
          # Main system configuration
          ./configuration.nix
          
          # Home Manager configuration
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPkgs = true;
              users.your-username = import ./home-manager/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}
