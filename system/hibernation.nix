{ config, pkgs, lib, ... }:

{
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 64 * 1024;
  }];

  boot.resumeDevice = "/dev/disk/by-uuid/656fa5b0-ae7b-46c6-9181-e575f4488b57";
  boot.kernelParams = [ "resume_offset=235018240" "mem_sleep_default=deep" ];

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';
}
