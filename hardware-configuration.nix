{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/656fa5b0-ae7b-46c6-9181-e575f4488b57";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."luks-2aef1b3a-60dd-47ea-bfe1-b521da512a54".device =
    "/dev/disk/by-uuid/2aef1b3a-60dd-47ea-bfe1-b521da512a54";
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7590-E605";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
