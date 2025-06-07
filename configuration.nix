{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  networking.hostName = "cho";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ko_KR.UTF-8" ];
    inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };

  fonts.packages = with pkgs; [ pretendard ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Pretendard" ];
    serif = [ "Pretendard" ];
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.pantheon.enable = true;
  };

  services.pantheon = {
    apps.enable = true;
    contractor.enable = true;
    xkb = {
      layout = "us,kr";
      variant = ",kr104";
      options = "grp:alt_space_toggle";
    };
  };

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

  users.users.sunghyun = {
    isNormalUser = true;
    description = "Sunghyun Cho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
    };

    shellAliases = {
      rebuild =
        "cd ~/Desktop/nixos && nixfmt *.nix && nix-channel --update && nix flake update && sudo nixos-rebuild switch --flake .#spaceship";
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      qqqq = "cd ~/Desktop/extracranial && bun run save";
      x = "exit";
    };
  };


  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ git zsh ibus ibus-engines.hangul ];

  system.stateVersion = "25.05";
}

