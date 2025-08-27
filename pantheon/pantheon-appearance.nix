{ pkgs, ... }:

{
  # Install Pantheon/Elementary icon theme
  home.packages = [ pkgs.elementary-icon-theme pkgs.hicolor-icon-theme ];

  # Set GTK interface preferences, including icon theme
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      font-name = "Pretendard 12";
      monospace-font-name = "Berkeley Mono 12";
      icon-theme = "elementary";
      clock-show-weekday = true;
      clock-format = "12h";
      enable-animations = false;
    };
  };
}

