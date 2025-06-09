{ pkgs, ... }:

{
  home.packages = [ pkgs.whitesur-icon-theme ];
  dconf.settings."org/gnome/desktop/interface".icon-theme = "WhiteSur-dark";
}
