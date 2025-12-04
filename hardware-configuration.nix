{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-74b5c3a9-da8c-417f-8369-924cb7e7f0d5";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-74b5c3a9-da8c-417f-8369-924cb7e7f0d5".device =
    "/dev/disk/by-uuid/74b5c3a9-da8c-417f-8369-924cb7e7f0d5";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/23BA-282F";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    { device = "/dev/mapper/luks-5dc5e1b8-5bec-47dc-ad64-2346cdd8fa8f"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
