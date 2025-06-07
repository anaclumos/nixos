{ config, pkgs, ... }:

{
  home.username = "sunghyun";
  home.homeDirectory = "/home/sunghyun";
  home.stateVersion = "25.05";

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Sunghyun Cho";
      userEmail = "hey@cho.sh";
      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "op-ssh-sign";
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
    };
  };

  home.packages = with pkgs; [
    # Development
    asdf-vm
    nodejs
    nodePackages.pnpm
    bun
    nixfmt-classic
    claude-code
    windsurf

    # Applications
    slack
    obsidian
    google-chrome
    bottles

    # System Tools
    xclip
    fastfetch
    tailscale
    adguardhome

    # Input Methods
    ibus
    ibus-engines.hangul
  ];
}
