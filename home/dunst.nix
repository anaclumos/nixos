{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        enable_posix_regex = "true";
      };
      "block-chrome" = {
        appname     = "Google Chrome";
        summary     = ".*(updated in the background|unread notifications).*";
        skip_display = "true";
      };
    };
  };
}