{ config, pkgs, lib, ... }: {
  imports = [
    ./keyboard.nix
    ./fonts/default.nix
    ./shell.nix
    ./1password.nix
    ./hibernation.nix
    ./gpu.nix
    ./radeon890m.nix
    ./rtx5090.nix
    ./gaming.nix
  ];
}
