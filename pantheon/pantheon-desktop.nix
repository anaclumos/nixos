{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Configure X11 keymap (needed for Pantheon)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Exclude some default Pantheon packages if needed
  environment.pantheon.excludePackages = with pkgs.pantheon; [
    # Add packages to exclude here if needed
    # For example:
    # elementary-mail
    # elementary-photos
  ];
}