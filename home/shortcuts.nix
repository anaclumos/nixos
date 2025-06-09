{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch or Focus Chrome";
      command = "wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable";
      binding = "<Ctrl><Alt><Super><Shift>j";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch or Focus Obsidian";
      command = "wmctrl -x -a obsidian.Obsidian || obsidian";
      binding = "<Ctrl><Alt><Super><Shift>o";
    };
  };
}