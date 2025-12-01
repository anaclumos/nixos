{ config, pkgs, lib, ... }: {
  services.hardware.bolt.enable = true;

  # Load thunderbolt early, before nvidia
  boot.initrd.availableKernelModules = [ "thunderbolt" ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # Disable D3cold for RTX 5090 eGPU - prevents "stuck in D3cold" issue
  services.udev.extraRules = ''
    # RTX 5090 - disable D3cold and keep power on
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x2b85", ATTR{d3cold_allowed}="0", ATTR{power/control}="on"
  '';

  # Critical kernel parameters for RTX 5090 eGPU stability
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "pcie_aspm=off"
    "pcie_port_pm=off"
    "thunderbolt.host_reset=false" # Fixes D3cold issue on kernel 6.8.8+
  ];

  programs.nix-ld.libraries = [ config.hardware.nvidia.package ];

  hardware.nvidia = {
    open =
      true; # REQUIRED for RTX 5090 (Blackwell) - proprietary modules not supported
    modesetting.enable = true;
    nvidiaPersistenced = true;
    powerManagement.enable = false; # Disabled - causes D3cold issues with eGPUs
    powerManagement.finegrained = false;
    prime.allowExternalGpu = true;
  };
  nixpkgs.config.cudaSupport = true;
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    nvidia-vaapi-driver
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    cudaPackages.cudnn
    cudaPackages.libcublas
    cudaPackages.libcufft
    cudaPackages.libcurand
    cudaPackages.libcusolver
    cudaPackages.libcusparse
  ];
}
