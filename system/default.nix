{ config, pkgs, lib, ... }:

{
  imports = [
    ./keyboard.nix
    ./fonts/default.nix
    ./shell.nix
    ./1password.nix
    ./hibernation.nix
  ];
}
