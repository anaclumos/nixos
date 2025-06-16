{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    kakaotalk.url = "github:anaclumos/kakaotalk.nix";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, kakaotalk, fw-fanctrl
    , ... }@inputs: {
      nixosConfigurations = {
        cho = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit kakaotalk fw-fanctrl; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
            fw-fanctrl.nixosModules.default
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
