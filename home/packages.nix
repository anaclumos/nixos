{ config, pkgs, inputs, ... }:

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
    code-cursor
    vscode
    gitAndTools.hub
    google-cloud-sdk
    gh
    prisma-engines
    codex
    ollama
    uv
    xclip
    warp-terminal
    scc
    ffmpeg-full

    # Applications
    slack
    obsidian
    google-chrome
    _1password-gui
    _1password-cli
    ookla-speedtest
    geekbench
    expressvpn
    caffeine-ng

    # System Tools
    xclip
    fastfetch
    tailscale
    adguardhome
    zsh-autosuggestions

    # GNOME
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.clipboard-history
    gnomeExtensions.framework-fan-control
    refine

    # Window Controls
    wmctrl
    xdotool
    keyd

    # Fonts
    pretendard

    # Icons
    hicolor-icon-theme
  ];
}
