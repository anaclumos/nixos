{ config, pkgs, lib, ... }:
let resumeDevice = "/dev/mapper/luks-067d3a16-727c-40f5-8510-a2cb221929cf";
in {
  boot.resumeDevice = resumeDevice;
  boot.kernelParams = [ "resume=${resumeDevice}" ];
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateMode=shutdown
  '';
}
