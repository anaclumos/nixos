{ pkgs, ... }:

{
  home.packages = [
    pkgs.whitesur-icon-theme
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard 11";
      monospace-font-name = "Berkeley Mono 10";
      icon-theme = "WhiteSur";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-animations = false;
    };
  };
}
