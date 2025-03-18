{ config, pkgs, lib, ... }:
{
  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
    };
  };
  
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
  ];
  
  programs.home-manager.enable = true;  
  programs.atuin.enable = false;
  
  # Zsh configuration with oh-my-zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "npm"
        "sudo"
        "command-not-found"
      ];
      theme = "robbyrussell";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";
  };
  
  home.stateVersion = "24.11";
}
