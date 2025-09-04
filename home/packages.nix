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
    gitAndTools.hub
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
    sqlitebrowser
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
  ];

  games = with pkgs; [ dolphin-emu bottles lutris ];

  applications = with pkgs; [
    slack
    teams-for-linux
    obsidian
    google-chrome
    firefox
    youtube-music
    _1password-gui
    _1password-cli
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
  ];

  gnomeTools = with pkgs; [ refine ];
in {
  home.packages = developmentTools ++ games ++ applications ++ gnomeTools
    ++ [ pkgs.pretendard inputs.kakaotalk.packages.x86_64-linux.kakaotalk ];
}
