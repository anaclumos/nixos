{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/notes/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/code-editor/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/team-chat/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chat/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/linear/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/music/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser" =
      {
        name = "Launch or Focus Chrome";
        command =
          "bash -c 'wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable'";
        binding = "<Ctrl><Alt><Super><Shift>j";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/notes" = {
      name = "Launch or Focus Obsidian";
      command = "bash -c 'wmctrl -x -a obsidian.Obsidian || obsidian'";
      binding = "<Ctrl><Alt><Super><Shift>o";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/code-editor" =
      {
        name = "Launch or Focus Cursor";
        command = "bash -c 'wmctrl -x -a cursor.Cursor || cursor'";
        binding = "<Ctrl><Alt><Super><Shift>semicolon";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" =
      {
        name = "Launch or Focus kgx";
        command = "bash -c 'wmctrl -x -a kgx.kgx || kgx'";
        binding = "<Ctrl><Alt><Super><Shift>apostrophe";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/team-chat" =
      {
        name = "Launch or Focus Slack";
        command = "bash -c 'slack'";
        binding = "<Ctrl><Alt><Super><Shift>n";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight" =
      {
        name = "GNOME Overview";
        command =
          "bash -c '${pkgs.dbus}/bin/dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chat" = {
      name = "Launch or Focus KakaoTalk";
      command =
        "bash -c 'wmctrl -x -a KakaoTalk || kakaotalk && wmctrl -x -a KakaoTalk'";
      binding = "<Ctrl><Alt><Super><Shift>m";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail" = {
      name = "Open Mail";
      command = "bash -c 'thunderbird-ui'";
      binding = "<Ctrl><Alt><Super><Shift>h";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/linear" = {
      name = "Open Linear";
      command = "${pkgs.xdg-utils}/bin/xdg-open https://linear.app";
      binding = "<Ctrl><Alt><Super><Shift>i";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/music" = {
      name = "Launch or Focus Youtube Music";
      command =
        "bash -c 'wmctrl -x -a com.github.th_ch.youtube_music.com.github.th_ch.youtube_music || youtube-music'";
      binding = "<Ctrl><Alt><Super><Shift>k";
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
        command = ''
          bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ "$current" == "'"'"'prefer-dark'"'"'" ]]; then gsettings set org.gnome.desktop.interface color-scheme '"'"'default'"'"'; else gsettings set org.gnome.desktop.interface color-scheme '"'"'prefer-dark'"'"'; fi'
        '';
        binding = "<Ctrl><Alt><Super><Shift>grave";
      };
  };
}
