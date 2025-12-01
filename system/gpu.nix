{ config, pkgs, lib, ... }: {
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
}
