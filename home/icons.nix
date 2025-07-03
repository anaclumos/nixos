{ pkgs, ... }:

{
  home.packages = [ pkgs.whitesur-icon-theme pkgs.hicolor-icon-theme ];
  dconf.settings."org/gnome/desktop/interface".icon-theme = "WhiteSur-dark";
}
