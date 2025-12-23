{ lib, pkgs, ... }: {
  programs.dconf.enable = true;

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
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
    gnome-text-editor
  ];

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/session" = { idle-delay = lib.gvariant.mkUint32 0; };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        sleep-inactive-battery-type = "nothing";
        sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0;
        power-button-action = "hibernate";
      };
    };
  }];
}
