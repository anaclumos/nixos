{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ./programs.nix { inherit config pkgs inputs; })
    (import ./packages.nix { inherit config pkgs inputs; })
    ./shortcuts.nix
    ./locale.nix
    ./icons.nix
    ./time.nix
  ];

  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";

  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
    ];
  };
}
