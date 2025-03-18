{ config, pkgs, ... }:
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
  ];
  
  programs.home-manager.enable = true;  
  programs.atuin.enable = false;
  
  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";
  };
  
  home.stateVersion = "24.11";
}
