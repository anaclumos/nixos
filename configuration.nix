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

  nixpkgs.config.allowUnfree = true;
  xdg.icons.enable = true;
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  environment.sessionVariables = {
    XDG_DATA_DIRS = lib.mkForce (lib.concatStringsSep ":" [
      "${pkgs.glib}/share"
      "/run/current-system/sw/share"
      "/home/sunghyuncho/.local/share"
    ]);
    PNPM_HOME = "/root/.local/share/pnpm";
    PATH = [ "/root/.local/share/pnpm" ];
    MUTTER_ALLOW_CUSTOM_SCALING_FACTORS = "1";
  };

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

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = { layout = "us"; };
  };

  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    gtk-theme='WhiteSur-Dark'
    icon-theme='WhiteSur'

    [org.gnome.desktop.wm.preferences]
    button-layout='appmenu:minimize,maximize,close'

    [org.gnome.desktop.background]
    show-desktop-icons=true
  '';

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
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
    packages = with pkgs; [
      git
      gitAndTools.hub
      asdf-vm
      nodejs
      nodePackages.pnpm
      bun
      nixfmt-classic
      claude-code
      slack
      obsidian
      ibus
      ibus-engines.hangul
      google-chrome
      windsurf
      adguardhome
      xclip
      fastfetch
      tailscale
      bottles
      steam
      google-cloud-sdk
      pretendard
    ];
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
    # GNOME packages
    gnome-tweaks
    dconf-editor
    whitesur-gtk-theme
    whitesur-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme

    # System packages
    uv
    _1password-gui
    _1password-cli
    docker-compose
    solaar
  ];

  fonts.packages = with pkgs; [ pretendard ];
  fonts.fontconfig.defaultFonts = {
    serif = [ "Pretendard" ];
    sansSerif = [ "Pretendard" ];
  };

  system.stateVersion = "24.11";
}
