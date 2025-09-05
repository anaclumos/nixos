{
  description = "NixOS configuration for Sunghyun's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    kakaotalk.url = "github:anaclumos/kakaotalk.nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      # Use fw-fanctrl's pinned nixpkgs to satisfy Python/jsonschema constraints
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, kakaotalk, fw-fanctrl
    , affinity-nix, ... }@inputs: {
      homeConfigurations.my-user = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        modules = [
          # ...
          {
            home.packages = [ affinity-nix.packages.x86_64-linux.photo ];
          }
        ];
      };
      nixosConfigurations = {
        cho = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./configuration.nix
            fw-fanctrl.nixosModules.default
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
