{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    epiphany
    gedit
    yelp
    seahorse
    gnome-connections
    gnome-tour
    xterm
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-photos
  ]);
}
