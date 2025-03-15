{
  description = "NixOS Configuration for sunghyuncho";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.sunghyuncho = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
}
