{ lib, ... }:

{
  # GNOME power and screen settings
  programs.dconf.profiles.user.databases = [{
    settings = {
      # Disable automatic screen blank
      "org/gnome/desktop/session" = { idle-delay = lib.gvariant.mkUint32 0; };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        sleep-inactive-battery-type = "suspend";
        sleep-inactive-battery-timeout = lib.gvariant.mkInt32 900;
        power-button-action = "hibernate";
      };
    };
  }];
}
