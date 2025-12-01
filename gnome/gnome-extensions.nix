{ pkgs, ... }: {
  home.packages = with pkgs.gnomeExtensions; [
    unite
    clipboard-history
    power-profile-switcher
    appindicator
    kimpanel
    dock-from-dash
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "unite@hardpixel.eu"
        "clipboard-history@alexsaveau.dev"
        "power-profile-switcher@eliapasquali.github.io"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dock-from-dash@fthx"
      ];
    };
    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Control>g" ];
    };
    "org/gnome/shell/extensions/power-profile-switcher" = {
      ac = "performance";
      bat = "performance";
      threshold = 80;
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
  };
}
