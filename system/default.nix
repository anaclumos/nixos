{ config, pkgs, lib, ... }: {
  imports = [ ./keyboard.nix ./fonts.nix ./1password.nix ];
  programs.zsh.enable = true;
}
