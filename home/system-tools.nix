{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    xclip
    wmctrl
    xdotool
    fastfetch
    zsh-autosuggestions
  ];
}
