{ pkgs, ... }: {
  home.packages = [
    pkgs.pantheon.elementary-icon-theme
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.whitesur-icon-theme
  ];
  dconf.settings = {
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
      enable-animations = false;
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
      ];
    };
  };
}
