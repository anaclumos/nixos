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
    packages = with pkgs; [
      git
      vscode
      google-chrome
      gitAndTools.hub
      spotify
      asdf-vm
      _1password-gui
      _1password-cli
      gh
      nodejs
      pkgs.claude-code
      nodePackages.pnpm
      slack
      ibus
      ibus-engines.hangul
      nixfmt-classic
      warp-terminal
      dconf-editor
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ zsh git zsh-autosuggestions ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "npm"
        "sudo"
        "command-not-found"
        "zsh-autosuggestions"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      rebuild = ''
        find . -name "*.nix" -type f | xargs nixfmt && sudo nix flake update && sudo nixos-rebuild switch'';
    };
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Sunghyun Cho";
      user.email = "hey@cho.sh";
      commit.gpgSign = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    };
  };

  programs._1password = { enable = true; };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sunghyuncho" ];
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

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
