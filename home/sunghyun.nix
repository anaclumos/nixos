{ config, pkgs, ... }:

{
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Sunghyun Cho";
      userEmail = "hey@cho.sh";
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "docker" "npm" ];
      };
      initContent = ''
        # Run Fastfetch on terminal start
        ${pkgs.fastfetch}/bin/fastfetch
      '';
    };
  };

  home.packages = with pkgs; [
    # Development Tools
    asdf-vm
    nodejs
    nodePackages.pnpm
    nodePackages.vercel
    bun
    nixfmt-classic
    claude-code
    windsurf
    vscode
    code-cursor
    gitAndTools.hub
    google-cloud-sdk
    gh

    # Applications
    slack
    obsidian
    google-chrome
    bottles
    steam
    _1password-gui
    geekbench

    # System Tools
    xclip
    fastfetch
    tailscale
    adguardhome
    zsh-autosuggestions

    # GNOME
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    
    refine

    # Window Controls
    wmctrl

    # Fonts
    pretendard
  ];

  # Locale settings
  home.language = {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    time = "en_US.UTF-8";
  };

  # Keyboard Shortcuts
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch or Focus Chrome";
      command = "wmctrl -x -a google-chrome.Google-chrome || google-chrome-stable";
      binding = "<Ctrl><Alt><Super><Shift>j";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch or Focus Obsidian";
      command = "wmctrl -x -a obsidian.Obsidian || obsidian";
      binding = "<Ctrl><Alt><Super><Shift>o";
    };
  };
}
