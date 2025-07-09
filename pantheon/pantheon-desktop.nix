{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Add Pantheon tweaks app and additional elementary packages
  environment.systemPackages = with pkgs; [ 
    pantheon-tweaks
    pantheon.elementary-greeter
    pantheon.elementary-session-settings
    pantheon.elementary-default-settings
  ];

  # Exclude some default Pantheon apps if needed
  environment.pantheon.excludePackages = with pkgs.pantheon;
    [
      # elementary-mail
      # elementary-photos
      # elementary-videos
    ];
}
