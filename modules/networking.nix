{ pkgs, ... }: {
  services.expressvpn.enable = true;
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.adguardhome.enable = true;
}
