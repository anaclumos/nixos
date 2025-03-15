{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ########################
  # Basic System Settings
  ########################

  networking.hostName = "sunghyuncho";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  ############################
  # Desktop (GNOME + X11)
  ############################

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable two layouts: English (us) and Korean (kr).
  # Assign left Win -> English (first layout group), 
  # right Win -> Korean (second layout group).
  services.xserver.xkb = {
    layout = "us,kr";
    # If you have a specific variant for Korean, you can specify 
    # variants = [ "" "kr104" ];
    options = [
      "grp:lwin_switch"
      "grp:rwin_switch"
    ];
  };

  ###############################
  # Audio (PipeWire + no Pulse)
  ###############################

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ######################
  # Printing
  ######################

  services.printing.enable = true;

  ######################
  # Boot Loader
  ######################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ########################################
  # Unfree Software & Misc. Settings
  ########################################

  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "code";

  #####################################
  # System Packages (via Flakes/Nix)
  #####################################

  environment.systemPackages = with pkgs; [
    vim
    wget
    onepassword-cli
    spotify
    google-chrome
    vscode
    _1password
  ];

  ####################################
  # User Account
  ####################################

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "Sunghyun Cho";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$y$jFT$GLgbtjnxvFZH41xn4Zkfk.$zUpKCR7/f1TKj.b1U4JkYHXBqgz70UeSjt0bwQv5478";
  };

  ###################################
  # System State Version
  ###################################

  system.stateVersion = "24.11";
}
