{ ... }: {
  services.expressvpn.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;
  services.tailscale.enable = true;
  services.adguardhome.enable = true;
}
