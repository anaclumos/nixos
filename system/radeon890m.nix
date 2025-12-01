{ config, pkgs, lib, ... }:

{
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

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
}
