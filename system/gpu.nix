{ config, pkgs, lib, ... }: {
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:3:0:0";
    amdgpuBusId = "PCI:193:0:0";
    offload.enable = true;
    offload.enableOffloadCmd = true;
    allowExternalGpu = true;
  };
}
