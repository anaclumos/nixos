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
    ollama
    xclip
    scc
    ffmpeg-full
    whois
    lefthook
    unzip
    zip
    act

    # Applications
    slack
    obsidian
    google-chrome
    youtube-music
    _1password-gui
    _1password-cli
    ookla-speedtest
    geekbench
    expressvpn
    caffeine-ng
    libreoffice
    zoom-us

    # System Tools
    xclip
    fastfetch
    adguardhome
    zsh-autosuggestions

    # GNOME
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.clipboard-history
    refine

    # Window Controls
    wmctrl
    xdotool
    keyd

    # Hyprland
    hyprland
    hyprpaper
    hyprpicker
    waybar
    wofi
    dunst
    swaylock
    swayidle
    wl-clipboard
    grim
    slurp

    # Fonts
    pretendard

    # Icons
    hicolor-icon-theme
  ];
}
