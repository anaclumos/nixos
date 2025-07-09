{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Enable Pantheon apps
  programs.pantheon-tweaks.enable = true;

  # Exclude some default Pantheon apps if needed
  environment.pantheon.excludePackages = with pkgs.pantheon;
    [
      # elementary-mail
      # elementary-photos
      # elementary-videos
    ];

  # Enable contractor for context menu actions
  services.contractor.enable = true;
}
