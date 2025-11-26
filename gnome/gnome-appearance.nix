{ pkgs, ... }:

{
  home.packages = [
    pkgs.pantheon.elementary-icon-theme
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard 12";
      document-font-name = "Pretendard 12";
      monospace-font-name = "Berkeley Mono 12";
      icon-theme = "Adwaita";
      cursor-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-hot-corners = false;
      # enable-animations = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Pretendard Bold 12";
    };

    "org/gnome/system/locale" = { region = "en_US.UTF-8"; };
  };
}
