{ pkgs, username, ... }:
let hostname = "framework";
in {
  imports = [
    ./hardware-configuration.nix
    ./fonts/default.nix
    ./modules/gnome.nix
    ./modules/options.nix
    ./modules/core.nix
    ./modules/gaming.nix
    ./modules/media.nix
    ./modules/networking.nix
  ];

  modules.user.name = username;
  modules.system.hostname = hostname;
  modules.system.timezone = "Asia/Seoul";
  modules.system.locale = "en_US.UTF-8";

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
  services.fwupd.enable = true;
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-hangul fcitx5-gtk ];
  };
  services.printing.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10min
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
