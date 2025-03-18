{ config, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
  ];
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "spaceship";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Time zone and locale
  time.timeZone = "Asia/Seoul";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
  
  # X11 and Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";  
      variant = "";
    };
  };
  
  # Printing
  services.printing.enable = true;
  
  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # User account
  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "sunghyuncho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # System packages
  environment.systemPackages = with pkgs; [
    zsh
    git
    home-manager
  ];
  
  # Enable zsh system-wide
  programs.zsh.enable = true;
  
  # Enable Flatpak
  services.flatpak.enable = true;
  
  # Fonts
  fonts.packages = with pkgs; [
    pretendard
  ];

  fonts.fontconfig.defaultFonts = {
    serif = [ "Pretendard" ];
    sansSerif = [ "Pretendard" ];
  };
  
  system.stateVersion = "24.11";
}
