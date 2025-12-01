{ config, pkgs, lib, ... }: {
  hardware.nvidia = {
    open = true;
    modesetting.enable = false;
    nvidiaPersistenced = true;
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
