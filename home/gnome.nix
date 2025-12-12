{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Icons
    pantheon.elementary-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme
    whitesur-icon-theme

    # Extensions
    gnomeExtensions.unite
    gnomeExtensions.clipboard-history
    gnomeExtensions.appindicator
    gnomeExtensions.kimpanel
    gnomeExtensions.dock-from-dash
  ];

  dconf.settings = {
    # Appearance
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard 12";
      document-font-name = "Pretendard 12";
      monospace-font-name = "Berkeley Mono 12";
      icon-theme = "WhiteSur";
      cursor-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-hot-corners = false;
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Pretendard Bold 12";
    };
    "org/gnome/system/locale" = { region = "en_US.UTF-8"; };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "thunderbird.desktop"
        "com.github.th_ch.youtube_music.desktop"
        "org.gnome.Calendar.desktop"
        "antigravity.desktop"
        "org.gnome.Console.desktop"
        "slack.desktop"
        "kakaotalk.desktop"
      ];
      enabled-extensions = [
        "unite@hardpixel.eu"
        "clipboard-history@alexsaveau.dev"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dock-from-dash@fthx"
      ];
    };

    # Extension Settings
    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Control>g" ];
    };
    "org/gnome/shell/extensions/unite" = {
      app-menu-ellipsize-mode = "start";
      desktop-name-text = "성현";
      extend-left-box = false;
      hide-activities-button = "always";
      hide-window-titlebars = "never";
      notifications-position = "center";
      reduce-panel-spacing = true;
      show-appmenu-button = true;
      show-window-buttons = "never";
      show-window-title = "always";
      use-activities-text = true;
    };

    # Keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/1password/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/dark-mode/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kakaotalk/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotlight" =
      {
        name = "GNOME Overview";
        command =
          "bash -c 'dbus-send --session --dest=org.gnome.Shell --type=method_call /org/gnome/Shell org.freedesktop.DBus.Properties.Set string:org.gnome.Shell string:OverviewActive variant:boolean:true'";
        binding = "<Ctrl>space";
      };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/jira" = {
      name = "Open Jira";
      command = "xdg-open https://lunit.atlassian.net/jira/core/projects/INCL2";
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
          "bash -c 'current=$(gsettings get org.gnome.desktop.interface color-scheme); if [[ \"$current\" == '''prefer-dark''' ]]; then gsettings set org.gnome.desktop.interface color-scheme ''''default'''; else gsettings set org.gnome.desktop.interface color-scheme ''''prefer-dark'''; fi'";
        binding = "<Ctrl><Alt><Super><Shift>grave";
      };
  };
}
