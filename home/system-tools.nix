{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    xclip
    wmctrl
    xdotool
    keyd
    fastfetch
    zsh-autosuggestions
  ];
}
