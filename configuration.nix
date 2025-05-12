{ config, pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;

  security.rtkit.enable = true;

  networking.hostName = "spaceship";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Seoul";
  time.hardwareClockInLocalTime = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ko_KR.UTF-8" ];
    inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
  environment.sessionVariables.LC_TIME = "ko_KR.UTF-8";

  services.xserver.desktopManager.pantheon.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    clock-format='12h'

    [io.elementary.wingpanel.datetime]
    clock-format='12h'
    show-weeks=true
    show-seconds=true

    [io.elementary.wingpanel.notifications]
    use-symbolic-icons=false

    [io.elementary.pantheon.notifications]
    use-symbolic-icons=false

    [io.elementary.desktop.wingpanel]
    use-symbolic-icons=true

    [org.pantheon.desktop.gala.appearance]
    button-layout=""
  '';

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
    };
    desktopManager.pantheon.enable = true;
    xkb = { layout = "us"; };
  };

  services.displayManager.hiddenUsers = [ "root" ];



  services.libinput = {
    enable = true;

    touchpad = {
      naturalScrolling = true;
      scrollMethod = "twofinger";
      accelSpeed = "0.5";
      accelProfile = "adaptive";
    };

    mouse = {
      accelProfile = "flat";
      middleEmulation = false;
    };
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = null;
    extraUpFlags = [ "--ssh" ];
  };

  networking.networkmanager = { enable = true; };

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "성현";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  programs._1password = { enable = true; };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  programs.nix-ld.enable = true;

  programs.ssh.startAgent = false;

  environment.etc = {
    "xdg/autostart/1password.desktop" = {
      source = "${pkgs._1password-gui}/share/applications/1password.desktop";
      mode = "0644";
    };
    "AccountsService/users/root".text = ''
      [User]
      SystemAccount=true
    '';
  };

  # Additional setting to hide root user
  users.users.root.isSystemUser = true;

  environment.systemPackages = with pkgs; [
    zsh
    zsh-autosuggestions
    git
    uv
    _1password-gui
    _1password-cli
    docker-compose
    solaar
  ];

  fonts.packages = with pkgs; [ pretendard ];

  # fonts.fontconfig.defaultFonts = {
  # serif = [ "Pretendard" ];
  # sansSerif = [ "Pretendard" ];
  # };

  environment.sessionVariables = {
    PNPM_HOME = "/root/.local/share/pnpm";
    PATH = [ "\${PNPM_HOME}" ];
  };

  system.stateVersion = "24.11";
}
