{ pkgs, ... }:

{
  home.packages = [ pkgs.whitesur-icon-theme pkgs.hicolor-icon-theme ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "WhiteSur-dark";
      clock-show-weekday = true;
      clock-format = "12h";
    };
  };
}
