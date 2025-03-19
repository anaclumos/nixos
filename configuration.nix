{ config, pkgs, lib, ... }: {

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.polkit.enable = true;
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

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
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

  users.users.sunghyuncho = {
    isNormalUser = true;
    description = "sunghyuncho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    # Packages are now managed by Home Manager
  };

  # Enable zsh at the system level
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ zsh git zsh-autosuggestions ];

  # zsh is now configured via Home Manager

  # Git is now configured via Home Manager

  # System-wide 1Password configuration
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  # SSH is now configured via Home Manager

  system.activationScripts = {
    sshSetup = {
      text = ''
        mkdir -p /home/sunghyuncho/.ssh
        if [ ! -f /home/sunghyuncho/.ssh/id_ed25519.pub ]; then
          echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt sunghyuncho@spaceship" > /home/sunghyuncho/.ssh/id_ed25519.pub
          chmod 644 /home/sunghyuncho/.ssh/id_ed25519.pub
          chown -R sunghyuncho:users /home/sunghyuncho/.ssh
        fi
        if [ ! -f /home/sunghyuncho/.ssh/config ]; then
          echo "Host *" > /home/sunghyuncho/.ssh/config
          echo "  IdentityAgent ~/.1password/agent.sock" >> /home/sunghyuncho/.ssh/config
          chmod 644 /home/sunghyuncho/.ssh/config
          chown -R sunghyuncho:users /home/sunghyuncho/.ssh
        fi
      '';
      deps = [ ];
    };

    gitAllowedSigners = {
      text = ''
        mkdir -p /home/sunghyuncho/.config/git
        if [ ! -f /home/sunghyuncho/.config/git/allowed_signers ]; then
          # Extract public key from your SSH key
          if [ -f /home/sunghyuncho/.ssh/id_ed25519.pub ]; then
            echo "hey@cho.sh $(cat /home/sunghyuncho/.ssh/id_ed25519.pub)" > /home/sunghyuncho/.config/git/allowed_signers
          else
            echo "hey@cho.sh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt" > /home/sunghyuncho/.config/git/allowed_signers
          fi
          chown -R sunghyuncho:users /home/sunghyuncho/.config/git
        fi
      '';
      deps = [ "sshSetup" ];
    };

    onePasswordAgentSetup = {
      text = ''
        mkdir -p /home/sunghyuncho/.1password
        chmod 700 /home/sunghyuncho/.1password
        chown -R sunghyuncho:users /home/sunghyuncho/.1password
      '';
      deps = [ ];
    };
  };

  services.flatpak.enable = true;

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
