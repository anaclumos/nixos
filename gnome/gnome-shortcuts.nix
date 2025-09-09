{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/linear/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight" =
      {
        name = "GNOME Overview";
        command =
          "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/linear" = {
      name = "Open Linear";
      command = "xdg-open https://linear.app";
      binding = "<Ctrl><Alt><Super><Shift>i";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock" = {
      name = "Lock Screen";
      command =
        "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
      binding = "<Ctrl>l";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password" =
      {
        name = "1Password Quick Access";
        command = "1password --quick-access";
        binding = "<Ctrl><Shift>space";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode" =
      {
        name = "Toggle Dark Mode";
        command =
          "bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ \"$current\" == \"'\"'\"'prefer-dark'\"'\"'\" ]]; then gsettings set org.gnome.desktop.interface color-scheme '\"'\"'default'\"'\"'; else gsettings set org.gnome.desktop.interface color-scheme '\"'\"'prefer-dark'\"'\"'; fi'";
        binding = "<Ctrl><Alt><Super><Shift>grave";
      };
  };
}
