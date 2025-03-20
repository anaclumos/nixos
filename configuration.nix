{ config, pkgs, lib, ... }: {

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;

  networking.hostName = "spaceship";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Asia/Seoul";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        scrollMethod = "twofinger";
        accelSpeed = "0.7";
        accelProfile = "adaptive";
      };
    };

    printing.enable = true;
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "성현";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    # Packages are now managed by Home Manager
  };

  # Enable zsh at the system level
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    zsh
    git
    zsh-autosuggestions
    _1password-cli
    _1password-gui
  ];

  programs._1password = { enable = true; };

  # Disable system SSH agent in favor of 1Password
  programs.ssh.startAgent = false;

  # Enhanced 1Password GUI configuration
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  services.flatpak = {
    enable = true;
    packages = [ "md.obsidian.Obsidian" ];
  };

  fonts.packages = with pkgs; [ pretendard ];
  fonts.fontconfig.defaultFonts = {
    serif = [ "Pretendard" ];
    sansSerif = [ "Pretendard" ];
  };

  environment.sessionVariables = {
    PNPM_HOME = "/root/.local/share/pnpm";
    PATH = [ "\${PNPM_HOME}" ];
  };

  system.stateVersion = "24.11";
}
