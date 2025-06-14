{ config, pkgs, lib, kakaotalk, ... }:

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
    totem # video player
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

