{ config, pkgs, lib, ... }: {

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;

  systemd.services.mute-startup-chime = {
    description = "Mute Mac startup chime";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.coreutils pkgs.util-linux ];
    script = ''
      if [ -f /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82 ]; then
        chattr -i /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82 || true
      fi
      printf "\x07\x00\x00\x00\x00" > /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82
      chattr +i /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82 || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

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

    adguardhome = {
      enable = true;
      openFirewall = true;
    };

    flatpak.enable = true;

    gnome = { };
  };

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "성현";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    zsh
    git
    zsh-autosuggestions
    _1password-cli
    _1password-gui
    adguardhome
    beeper
  ];

  programs._1password = { enable = true; };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  programs.ssh.startAgent = false;

  environment.etc = {
    "xdg/autostart/1password.desktop" = {
      source = "${pkgs._1password-gui}/share/applications/1password.desktop";
      mode = "0644";
    };

    "xdg/autostart/beeper.desktop" = {
      source = "${pkgs.beeper}/share/applications/beeper.desktop";
      mode = "0644";
    };
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
