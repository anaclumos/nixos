{ config, pkgs, lib, kakaotalk, fw-fanctrl, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Allow any unfree package globally
  nixpkgs.config.allowUnfreePredicate = _: true;
  imports = [
    ./hardware-configuration.nix
    ./keyboard.nix
    ./font.nix
    ./shell.nix
    ./1password.nix
    ./lunit.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;
  services.fprintd.enable = true;
  services.expressvpn.enable = true;

  # Enable fw-fanctrl
  programs.fw-fanctrl.enable = true;

  # Add a custom config
  programs.fw-fanctrl.config = {
    defaultStrategy = "Gentle";
    strategies = {
      "Turbo" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 20;
          }
          {
            temp = 10;
            speed = 40;
          }
          {
            temp = 20;
            speed = 60;
          }
          {
            temp = 30;
            speed = 80;
          }
          {
            temp = 40;
            speed = 100;
          }
        ];
      };
      "Gentle" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 0;
          }
          {
            temp = 15;
            speed = 20;
          }
          {
            temp = 30;
            speed = 40;
          }
          {
            temp = 45;
            speed = 60;
          }
          {
            temp = 60;
            speed = 80;
          }
          {
            temp = 75;
            speed = 100;
          }
        ];
      };
    };
  };

  networking.hostName = "cho";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    cheese # photo booth
    eog # image viewer
    epiphany # web browser
    gedit # text editor
    simple-scan # document scanner
    # totem # video player
    yelp # help viewer
    evince # document viewer
    file-roller # archive manager
    geary # email client
    seahorse # password manager
    gnome-calculator
    # gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-weather
    # gnome-disk-utility
    pkgs.gnome-connections
    gnome-tour
    xterm
  ];

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.flatpak.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    zsh
    kakaotalk.packages.${pkgs.system}.kakaotalk
  ];

  system.stateVersion = "25.05";
}

