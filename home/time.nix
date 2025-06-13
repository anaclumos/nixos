{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      clock-format = "12h";
    };
  };
}
