{ config, pkgs, lib, inputs, ... }:
let
  user = "sunghyun";
  hostname = "framework";
in {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./hardware-configuration.nix
    ./gnome/gnome-desktop.nix
    ./gnome/gnome-power.nix
    ./system/default.nix
    ./dev/default.nix
    ./modules/user.nix
    ./modules/config.nix
  ];

  modules.user.name = user;
  modules.system.hostname = hostname;
  modules.system.timezone = "Asia/Seoul";

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."luks-067d3a16-727c-40f5-8510-a2cb221929cf" = {
    device = "/dev/disk/by-uuid/067d3a16-727c-40f5-8510-a2cb221929cf";
    preLVM = true;
    allowDiscards = true;
  };
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.expressvpn.enable = true;
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Seoul";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-hangul fcitx5-gtk ];
    };
  };
  services.tailscale.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  services.printing.enable = true;

  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # Power management & hibernation
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateMode=shutdown
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libsndfile ];
  environment.systemPackages = with pkgs; [ ];
  environment.variables = {
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:/run/opengl-driver/lib";
  };
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "0";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  system.stateVersion = "25.11";
}
