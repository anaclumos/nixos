{ ... }: {
  services.expressvpn.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  services.tailscale.enable = true;
  services.adguardhome.enable = true;
}
