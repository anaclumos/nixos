{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs;
    [
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

      ## Games
      dolphin-emu
      bottles

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
      beeper
      pngcrush

      # System Tools
      xclip
      fastfetch
      adguardhome
      zsh-autosuggestions

      # GNOME
      gnomeExtensions.gtk4-desktop-icons-ng-ding
      gnomeExtensions.clipboard-history
      gnomeExtensions.auto-power-profile
      gnomeExtensions.appindicator
      gnomeExtensions.user-themes
      refine

      # Window Controls
      wmctrl
      xdotool
      keyd

      # Fonts
      pretendard

      # Icons
      hicolor-icon-theme
    ] ++ [
      inputs.kakaotalk.packages.x86_64-linux.kakaotalk
      inputs.affinity-nix.packages.x86_64-linux.photo
      inputs.affinity-nix.packages.x86_64-linux.publisher
      inputs.affinity-nix.packages.x86_64-linux.designer
    ];
}
