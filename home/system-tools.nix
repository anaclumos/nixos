{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Clipboard
    xclip

    # Window Controls
    wmctrl
    xdotool
    keyd

    # System Info
    fastfetch

    # Network
    adguardhome

    # Shell
    zsh-autosuggestions

    # Fan control CLI (for GNOME extension integration)
    fw-fanctrl
  ];
}
