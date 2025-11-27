{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    unite
    clipboard-history
    auto-power-profile
    appindicator
    kimpanel
    dock-from-dash
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "unite@hardpixel.eu"
        "clipboard-history@alexsaveau.dev"
        "auto-power-profile@dmy3k.github.io"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dock-from-dash@fthx"
      ];
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Control>g" ];
    };

    "org/gnome/shell/extensions/auto-power-profile" = {
      ac = "balanced";
      bat = "power-saver";
    };
  };
}
