{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Allow any unfree package globally
  nixpkgs.config.allowUnfreePredicate = _: true;
  imports = [
    ./hardware-configuration.nix
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
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.tailscale.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    # baobab # disk usage analyzer
    # cheese # photo booth
    # eog # image viewer
    epiphany # web browser
    gedit # text editor
    # simple-scan # document scanner
    # totem # video player
    yelp # help viewer
    # evince # document viewer
    # file-roller # archive manager
    # geary # email client
    seahorse # password manager
    # gnome-calculator
    # gnome-calendar
    # gnome-characters
    # gnome-clocks
    gnome-contacts
    # gnome-font-viewer
    # gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    # gnome-screenshot
    # gnome-system-monitor
    # gnome-weather
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

  system.stateVersion = "25.05";
}

