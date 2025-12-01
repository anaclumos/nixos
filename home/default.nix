{ config, pkgs, inputs, ... }: {
  imports = [
    ./programs.nix
    ./packages.nix
    ./system-tools.nix
    ./gcloud.nix
    ./locale.nix
    ./fcitx5.nix
    ./thunderbird.nix
    ../gnome/gnome-extensions.nix
    ../gnome/gnome-shortcuts.nix
    ../gnome/gnome-appearance.nix
  ];
  dconf.enable = true;
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.11";
  services.mpris-proxy.enable = true;
}
