{ pkgs, lib, ... }:

{
  # Enable the X server and Pantheon desktop environment
  services.xserver.enable = true;

  # LightDM with Pantheon greeter
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;

  # Enable Pantheon desktop session
  services.xserver.desktopManager.pantheon.enable = true;
}
