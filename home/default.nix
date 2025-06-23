{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ./programs.nix { inherit config pkgs inputs; })
    (import ./packages.nix { inherit config pkgs inputs; })
    ./shortcuts.nix
    ./locale.nix
    ./icons.nix
    ./time.nix
    ./gnome.nix
  ];

  dconf.enable = true;
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";

  services.flatpak = {
    enable = true;
    packages = [ "com.usebottles.bottles" "app.zen_browser.zen" ];
  };

  # Bluetooth headset media controls
  services.mpris-proxy.enable = true;
}
