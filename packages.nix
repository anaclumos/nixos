{ pkgs, pkgs-unstable, inputs }:
let
  developmentTools = with pkgs-unstable; [
    # Languages & Runtimes
    nodejs
    bun
    uv
    ruff

    # Package Managers & Build Tools
    nodePackages.pnpm
    nodePackages.vercel
    cmake
    gcc
    gnumake
    pkg-config
    moon
    lefthook

    # Code Editors & IDEs
    claude-code
    vscode
    vscode-extensions.biomejs.biome

    # Version Control & Git (git managed by programs.git)
    hub
    gh

    # Cloud & Infrastructure
    terraform
    argocd
    k9s
    kubectl
    azure-cli
    azure-storage-azcopy
    cloudflared

    # AI & Coding Assistants
    codex
    gemini-cli
    opencode

    # Nix Tools
    nixfmt-classic
    comma
    nix-index

    # Database
    mariadb

    # CLI Utilities
    scc
    whois
    unzip
    zip
    act
    biome
    lsof
    tmux
    wget
    jq
    openssl
    librsvg

    # Image Processing CLI
    pngcrush
    imagemagick
    pngquant

    # Document Processing
    tectonic
    tex-fmt

    # Shell (zsh managed by programs.zsh)
    cacert

    # Container Tools
    docker-compose
    _1password-cli

    # LLM Tools
    ollama
    ramalama
  ];

  mediaTools = with pkgs-unstable; [ ffmpeg-full libheif libsndfile ];

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
    # Communication
    slack
    teams-for-linux
    beeper
    zoom-us
    telegram-desktop
    inputs.kakaotalk.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Browsers
    google-chrome

    # Productivity
    obsidian
    logseq
    sticky-notes

    # Media
    spotify

    # Security & VPN
    _1password-gui
    expressvpn

    # Utilities
    caffeine-ng
    timewall
    trayscale

    # Database & Dev Tools
    sqlitebrowser
    inputs.tableplus.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Benchmarks
    geekbench
  ];

  gnomeTools = with pkgs; [ refine ];

  systemTools = with pkgs; [
    # Clipboard & Window Management
    xclip
    wmctrl
    xdotool

    # Hardware Info
    pciutils
    nvme-cli

    # Monitoring
    btop

    # Notifications
    libnotify
  ];

  cloudTools = with pkgs;
    [
      (google-cloud-sdk.withExtraComponents
        [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];

  iconThemes = with pkgs; [
    pantheon.elementary-icon-theme
    hicolor-icon-theme
    adwaita-icon-theme
    colloid-icon-theme
  ];

  gnomeExtensionsList = with pkgs; [
    gnomeExtensions.unite
    gnomeExtensions.clipboard-history
    gnomeExtensions.appindicator
    gnomeExtensions.media-controls
    gnomeExtensions.kimpanel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.desktop-icons-ng-ding
    gnomeExtensions.blur-my-shell
  ];

in {
  inherit developmentTools mediaTools games applications gnomeTools systemTools
    cloudTools iconThemes gnomeExtensionsList;
}
