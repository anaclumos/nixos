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
      monospace-font-name = "Berkeley Mono 12";
      icon-theme = "Adwaita";
      cursor-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-animations = true;
    };
  };
}
