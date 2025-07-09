{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Allow any unfree package globally
  nixpkgs.config.allowUnfreePredicate = _: true;
  imports = [
    ./hardware-configuration.nix
    ./gnome/gnome-desktop.nix
    ./system/keyboard.nix
    ./system/fonts/default.nix
    ./system/shell.nix
    ./system/1password.nix
    ./dev/git.nix
    ./dev/lunit.nix
    ./dev/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Track the latest Linux kernel release for improved hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable fingerprint reader support
  services.fprintd.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  services.expressvpn.enable = true;

  networking.hostName = "cho";
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
  services.blueman.enable = true;

  services.printing.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  environment.systemPackages = with pkgs; [ git zsh cacert uv ];

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

