{ config, lib, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        extraConfig = ''
          [main]
          capslock = overload(hyper, macro(A-f10))
          leftalt = layer(mac_command)
          rightalt = rightcontrol
          leftmeta = layer(mac_alt)
          rightmeta = layer(mac_alt)
          leftcontrol = layer(mac_control)
          rightcontrol = layer(mac_control)

          [mac_command:C]
          c = C-insert
          v = S-insert
          x = S-delete
          [ = A-left
          ] = A-right
          tab = swapm(app_switch_state, A-tab)
          left = home
          up = pageup
          right = end
          down = pagedown

          [mac_command+shift]
          c = C-S-c

          [app_switch_state:A]
          backspace = C-backspace

          [mac_alt:A]
          left = C-left
          right = C-right
          backspace = C-backspace

          [mac_control:C]
          left = M-pageup
          right = M-pagedown

          [hyper:C-A-S-M]
          left = M-left
          right = M-right
          enter = macro(M-S-end M-up)
        '';
      };
    };
  };
}
