{ config, pkgs, inputs, ... }:

{
  imports = [
    ./programs.nix
    ./packages.nix
    ./system-tools.nix
    ./phoenix.nix
    ./gcloud.nix
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
