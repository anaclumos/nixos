{ config, pkgs, lib, ... }:
let
  # Use the mapped swap device by its UUID so the generator/EFI info matches
  swapUuid = "a59adc7d-7a40-4a08-b569-b323c1e9dd1a";
  resumeDevice = "/dev/disk/by-uuid/${swapUuid}";
in {
  boot.initrd.systemd.enable = true;
  boot.resumeDevice = resumeDevice;
  boot.initrd.systemd.services.systemd-hibernate-resume = {
    after = [ "cryptsetup.target" ];
    wants = [ "cryptsetup.target" ];
  };
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
  systemd.services."systemd-hibernate".environment = {
    SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
  };
  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateMode=shutdown
  '';
}
