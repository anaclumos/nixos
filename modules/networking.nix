{ pkgs, ... }: {
  services.expressvpn.enable = true;
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.adguardhome.enable = true;

  # ============================================
  # MediaTek MT7925 WiFi Stability Fixes
  # ============================================
  # Known issues: ASPM causes hangs, power management causes disconnects,
  # CLC causes 6GHz instability, WiFi fails to reconnect after suspend.
  # Sources:
  # - https://github.com/robcohen/dotfiles/blob/main/modules/hardware/mt7925.nix
  # - https://github.com/AdrielVelazquez/nixos-config/blob/main/modules/system/mediatek-wifi.nix
  # - https://community.frame.work/t/issues-with-mediatek-mt7925-rz717-wi-fi-card/75815

  # Kernel module options to disable problematic power management
  boot.extraModprobeConfig = ''
    # Disable ASPM (Active State Power Management) - causes hangs and disconnects
    options mt7925e disable_aspm=1
    # Disable Country Location Code - causes 6GHz instability
    options mt7925_common disable_clc=1
  '';

  # NetworkManager WiFi settings
  networking.networkmanager.wifi = {
    powersave = false;
    scanRandMacAddress = false; # Consistent MAC during scans
  };

  # Fix WiFi after suspend/resume - driver gets into bad state
  systemd.services.mt7925-resume-fix = {
    description = "Restart NetworkManager after suspend to fix MT7925 WiFi";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager";
    };
  };
}
