{ config, pkgs, lib, ... }:

{
  # Shared graphics configuration
  hardware.graphics.enable = true;

  # Video drivers for both GPUs
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # PRIME configuration for hybrid graphics (AMD iGPU + NVIDIA eGPU)
  hardware.nvidia.prime = {
    # RTX 5090 eGPU (03:00.0 hex = 3:0:0 decimal)
    nvidiaBusId = "PCI:3:0:0";

    # Radeon 890M iGPU (c1:00.0 hex = 193:0:0 decimal)
    amdgpuBusId = "PCI:193:0:0";

    # Offload mode - GPU sleeps when unused
    offload.enable = true;
    offload.enableOffloadCmd = true;

    # Allow external GPU (eGPU)
    allowExternalGpu = true;
  };
}
