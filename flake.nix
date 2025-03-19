{
  description = "Sunghyun Cho's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.spaceship = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
