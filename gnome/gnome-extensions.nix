{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    gtk4-desktop-icons-ng-ding
    clipboard-history
    auto-power-profile
    appindicator
    unite
    kimpanel
    dock-from-dash
    framework-fan-control
    run-or-raise
  ];
}
