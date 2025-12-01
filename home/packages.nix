{ config, pkgs, inputs, ... }:
let
  developmentTools = with pkgs; [
    nodejs
    nodePackages.pnpm
    nodePackages.vercel
    bun
    nixfmt-classic
    claude-code
    code-cursor
    vscode
    hub
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
    terraform
    biome
    vscode-extensions.biomejs.biome
    argocd
    k9s
    kubectl
    moon
    git
    zsh
    cacert
    uv
    ruff
    comma
    mariadb
    pkg-config
    nix-index
    codex
    ripgrep
    lsof
    vtracer
    azure-cli
    azure-storage-azcopy
    gemini-cli
    tmux
    cmake
    gcc
    gnumake
    nvme-cli
    wget
    podman-compose
    _1password-cli
    pciutils
  ];
  games = with pkgs; [
    dolphin-emu
    bottles
    (lutris.override { extraPkgs = pkgs: [ pkgs.libnghttp2 pkgs.winetricks ]; })
    wineWowPackages.staging
    winetricks
    vulkan-tools
    dxvk
  ];
  applications = with pkgs; [
    slack
    teams-for-linux
    obsidian
    google-chrome
    firefox
    youtube-music
    _1password-gui
    ookla-speedtest
    geekbench
    expressvpn
    caffeine-ng
    zoom-us
    beeper
    pngcrush
    imagemagick
    pngquant
    logseq
    podman-desktop
    pods
    sqlitebrowser
  ];
  gnomeTools = with pkgs; [ refine ];
in {
  home.packages = developmentTools ++ games ++ applications ++ gnomeTools
    ++ [ pkgs.pretendard pkgs.monaspace ];
}
