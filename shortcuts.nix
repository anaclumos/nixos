{ config, pkgs, lib, ... }:

{
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;

  environment.etc."dconf/db/local.d/00-media-keys".text = ''
    [org/gnome/settings-daemon/plugins/media-keys]
    custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
    binding='<Ctrl><Alt><Shift><Super>j'
    command='wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable'
    name='Launch/Focus Chrome'
  '';

  system.activationScripts.setup-dconf = ''
    ${pkgs.dconf}/bin/dconf update
  '';
}
