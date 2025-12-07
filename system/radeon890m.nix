{ config, pkgs, lib, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        clr
        hip-common
        hipblas
        rocblas
        rocsolver
        rocm-smi
        rocminfo
      ];
    };
  in [ "L+ /opt/rocm - - - - ${rocmEnv}" ];
  services.lact.enable = true;
  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    lact
  ];
  users.users.sunghyun.extraGroups = [ "render" ];
  environment.variables = {
    # ROCm 6.0+ might need this for consumer cards (RDNA 3 / 3.5)
    # Strix Point (Radeon 890M) is RDNA 3.5, which is compatible with gfx1100 (RDNA 3)
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
