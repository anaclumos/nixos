{ config, pkgs, lib, inputs, ... }:

let
  user = "sunghyun";
  hostname = "cho";

in {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./hardware-configuration.nix
    ./gnome/default.nix
    ./system/default.nix
    ./dev/default.nix
    ./modules/user.nix
    ./modules/config.nix
  ];

  # Module configuration
  modules.user.name = user;
  modules.system.hostname = hostname;
  modules.system.timezone = "Asia/Seoul";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
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

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.printing.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  environment.systemPackages = with pkgs; [
    # Install KakaoTalk at the system level so the binary is always
    # available at /run/current-system/sw/bin/kakaotalk regardless of
    # Home Manager state or user profiles.
    inputs.kakaotalk.packages.x86_64-linux.kakaotalk
  ];

  environment.variables = {
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "0";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  system.stateVersion = "25.05";
}
