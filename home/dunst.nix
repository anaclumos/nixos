{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        enable_posix_regex = "true";
      };
      "block-chrome-background" = {
        appname     = "Google Chrome";
        summary     = ".*updated in the background.*";
        skip_display = "true";
      };
      "block-chrome-unread" = {
        appname     = "Google Chrome";
        summary     = ".*unread notifications.*";
        skip_display = "true";
      };
      "block-kakaotalk-is-ready" = {
        appname     = "카카오톡";
        summary     = ".*is ready*";
        skip_display = "true";
      };
    };
  };
}