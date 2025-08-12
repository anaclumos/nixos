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
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13/"
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
        name = "Launch or Focus VS Code";
        command = "bash -c 'wmctrl -x -a code.Code || code'";
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
        command = "bash -c 'slack'";
        binding = "<Ctrl><Alt><Super><Shift>n";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" =
      {
        name = "GNOME Overview";
        command =
          "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" =
      {
        name = "Launch or Focus KakaoTalk";
        command =
          "bash -c 'wmctrl -x -a KakaoTalk || kakaotalk && wmctrl -x -a KakaoTalk'";
        binding = "<Ctrl><Alt><Super><Shift>m";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" =
      {
        name = "Open Calendar";
        command =
          "bash -c 'thunderbird-ui --calendar'";
        binding = "<Ctrl><Alt><Super><Shift>l";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8" =
      {
        name = "Open Mail";
        command =
          "bash -c 'thunderbird-ui --mail'";
        binding = "<Ctrl><Alt><Super><Shift>h";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9" =
      {
        name = "Open Linear";
        command = "xdg-open https://linear.app";
        binding = "<Ctrl><Alt><Super><Shift>i";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10" =
      {
        name = "Launch or Focus Youtube Music";
        command =
          "bash -c 'wmctrl -x -a com.github.th_ch.youtube_music.com.github.th_ch.youtube_music || youtube-music'";
        binding = "<Ctrl><Alt><Super><Shift>k";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11" =
      {
        name = "Lock Screen";
        command =
          "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
        binding = "<Ctrl>l";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12" =
      {
        name = "1Password Quick Access";
        command = "1password --quick-access";
        binding = "<Ctrl><Shift>space";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13" =
      {
        name = "Toggle Dark Mode";
        command =
          "bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ \"$current\" == \"'\"'\"'prefer-dark'\"'\"'\" ]]; then gsettings set org.gnome.desktop.interface color-scheme '\"'\"'default'\"'\"'; else gsettings set org.gnome.desktop.interface color-scheme '\"'\"'prefer-dark'\"'\"'; fi'";
        binding = "<Ctrl><Alt><Super><Shift>grave";
      };
  };
}
