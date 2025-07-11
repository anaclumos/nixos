{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs;
    [
      # Development Tools
      nodejs
      nodePackages.pnpm
      nodePackages.vercel
      bun
      nixfmt-classic
      claude-code
      code-cursor
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
      sqlitebrowser
      gimp
      terraform

      # Games
      dolphin-emu
      bottles

      # Applications
      slack
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
      libreoffice
      zoom-us
      beeper
      pngcrush
      imagemagick
      pngquant
      gimp
      thunderbird

      # System Tools
      xclip
      fastfetch
      adguardhome
      zsh-autosuggestions

      # GNOME tools
      refine

      # Window Controls
      wmctrl
      xdotool
      keyd

      # Fonts
      pretendard
    ] ++ [ inputs.kakaotalk.packages.x86_64-linux.kakaotalk ];
}
