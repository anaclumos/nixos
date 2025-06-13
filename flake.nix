{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs: {
    nixosConfigurations = {
      cho = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.sunghyun = import ./home;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              { nixpkgs.config.allowUnfree = true; }
              nix-flatpak.homeManagerModules.nix-flatpak
            ];
          }
        ];
      };
    };
  };
}
