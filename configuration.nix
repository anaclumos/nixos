{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  networking.hostName = "cho";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.sunghyun = {
    isNormalUser = true;
    description = "Sunghyun Cho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  
  programs.git = {
    enable = true;
    config = {
      user.name = "Sunghyun Cho";
      user.email = "hey@cho.sh";
      gpg.format = "ssh";
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      commit.gpgsign = true;
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
    };
  };
  
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    zsh
    zsh-autosuggestions
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
    vscode
    _1password-gui
    _1password-cli
  ];

  system.stateVersion = "25.05";
}

