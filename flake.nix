{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # kakaotalk.url = "path:/home/sunghyun/Desktop/nix/kakaotalk.nix";
    kakaotalk.url = "github:anaclumos/kakaotalk.nix";
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-hardware, kakaotalk, ... }@inputs: {
      nixosConfigurations = {
        cho = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
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
