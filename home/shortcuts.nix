{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        name = "Launch or Focus Chrome";
        command =
          "bash -c 'wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable'";
        binding = "<Ctrl><Alt><Super><Shift>j";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        name = "Launch or Focus Obsidian";
        command = "bash -c 'wmctrl -x -a obsidian.Obsidian || obsidian'";
        binding = "<Ctrl><Alt><Super><Shift>o";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
      {
        name = "Launch or Focus Cursor";
        command = "bash -c 'wmctrl -x -a cursor.Cursor || cursor'";
        binding = "<Ctrl><Alt><Super><Shift>semicolon";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" =
      {
        name = "Launch or Focus kgx";
        command = "bash -c 'wmctrl -x -a kgx.kgx || kgx'";
        binding = "<Ctrl><Alt><Super><Shift>apostrophe";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" =
      {
        name = "Launch or Focus Slack";
        command = "bash -c 'wmctrl -x -a slack.Slack || slack'";
        binding = "<Ctrl><Alt><Super><Shift>n";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" =
      {
        name = "GNOME Overview";
        command =
          "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };
  };
}
