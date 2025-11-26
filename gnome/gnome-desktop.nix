{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    evince
    geary
  ]);
}
