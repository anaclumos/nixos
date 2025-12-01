{ config, pkgs, lib, ... }: {
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 64 * 1024;
  }];
  boot.resumeDevice = config.fileSystems."/".device;
  boot.kernelParams = [ "resume_offset=235018240" ];
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
    HibernateDelaySec=10m
    SuspendState=mem
  '';
}
