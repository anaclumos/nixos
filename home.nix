{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";

  # Keyboard remapping configuration
  home.keyboard = { layout = "us"; };

  home.packages = with pkgs; [
    git
    vscode
    google-chrome
    gitAndTools.hub
    spotify
    asdf-vm
    _1password-cli
    _1password-gui
    gh
    (lib.hiPrio windsurf)
    nodejs
    pnpm
    slack
    ibus
    ibus-engines.hangul
    nixfmt
  ];

  programs.home-manager.enable = true;
  programs.atuin.enable = false;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      export PNPM_HOME="/root/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
    '';
  };

  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";
  };

  # Configure SSH with 1Password
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  home.stateVersion = "24.11";
}
