{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    gtk4-desktop-icons-ng-ding
    clipboard-history
    auto-power-profile
    appindicator
    kimpanel
    dock-from-dash
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "gtk4-ding@smedius.gitlab.com"
        "clipboard-history@alexsaveau.dev"
        "auto-power-profile@dmy3k.github.io"
        "appindicatorsupport@rgcjonas.gmail.com"
        "kimpanel@kde.org"
        "dock-from-dash@fthx"
      ];
    };
  };
}
