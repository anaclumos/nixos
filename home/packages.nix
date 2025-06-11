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
    code-cursor
    gitAndTools.hub
    google-cloud-sdk
    gh
    prisma-engines
    codex
    ollama

    # Applications
    slack
    obsidian
    google-chrome
    bottles
    _1password-gui
    _1password-cli
    ookla-speedtest
    geekbench
    expressvpn

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
