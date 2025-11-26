{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    kakaotalk.url = "path:/home/sunghyun/Desktop/nix/kakaotalk.nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, kakaotalk
    , affinity-nix, ... }@inputs: {
      nixosConfigurations = {
        cho = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            { nixpkgs.config.allowUnfree = true; }
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.sunghyun = import ./home;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules =
                [{ nixpkgs.config.allowUnfree = true; }];
            }
          ];
        };
      };
    };
}
