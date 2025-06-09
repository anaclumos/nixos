{ config, lib, pkgs, ... }:

{
  # GNOME Custom Shortcuts Configuration
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Ctrl><Alt><Shift><Super>j";
      command = "wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable";
      name = "Launch/Focus Chrome";
    };
  };
}