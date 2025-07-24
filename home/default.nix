{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ./programs.nix { inherit config pkgs inputs; })
    (import ./packages.nix { inherit config pkgs inputs; })
    (import ./phoenix.nix { inherit config pkgs inputs; })
    (import ./gcloud.nix { inherit config pkgs inputs; })
    ../gnome/gnome-extensions.nix
    ../gnome/gnome-shortcuts.nix
    ../gnome/gnome-appearance.nix
    ./locale.nix
    ./fcitx5.nix
  ];

  dconf.enable = true;
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";

  # Bluetooth headset media controls
  services.mpris-proxy.enable = true;
}
