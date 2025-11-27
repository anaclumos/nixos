{ lib, ... }:

{
  # GNOME power and screen settings
  programs.dconf.profiles.user.databases = [{
    settings = {
      # Disable automatic screen blank
      "org/gnome/desktop/session" = {
        idle-delay = lib.gvariant.mkUint32 0;
      };

      # Disable automatic suspend when plugged in (AC power)
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
    };
  }];
}
