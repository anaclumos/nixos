{ config, pkgs, ... }:

{
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
}
