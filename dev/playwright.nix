{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    playwright-driver.browsers
    nodejs
  ];

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}