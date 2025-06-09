{ config, pkgs, ... }:

{
  imports = [
    ./programs.nix
    ./packages.nix
    ./shortcuts.nix
    ./locale.nix
    ./icons.nix
  ];

  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";
}
