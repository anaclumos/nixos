{ config, pkgs, inputs, ... }: {
  imports = [
    ./programs.nix
    ./packages.nix
    ./fcitx5.nix
    ./thunderbird.nix
    ./timewall.nix
    ../gnome/gnome-extensions.nix
    ../gnome/gnome-shortcuts.nix
    ../gnome/gnome-appearance.nix
  ];
  dconf.enable = true;
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.11";
  services.mpris-proxy.enable = true;

  # Locale
  home.language = {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    time = "en_US.UTF-8";
  };
}
