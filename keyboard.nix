{ config, lib, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "*"
        ]; # what goes into the [id] section, here we select all keyboard
        # extraConfig = builtins.readFile /home/deftdawg/source/meta-mac/keyd/kde-mac-keyboard.conf; # use includes when debugging, easier to edit in vs code or others
        extraConfig = ''
          # Use Alt as "command" key and Super/Windows as "alt" key
          [main]
          # Map Caps Lock to Hyper Key (Ctrl+Alt+Shift+Super)
          capslock = overload(hyper, M-up)

          leftalt = layer(software_command)
          rightalt = rightcontrol

          leftmeta = layer(software_alt)
          rightmeta = layer(software_alt)

          leftcontrol = layer(software_control)
          rightcontrol = layer(software_control)

          [software_command:C]
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
          backspace = C-S-k

          [app_switch_state:A]
          backspace = C-backspace

          [software_alt:A]
          left = C-left
          right = C-right
          backspace = C-backspace

          [software_control:C]
          left = M-pageup
          right = M-pagedown

          [hyper:C-A-S-M]
          left = M-left
          right = M-right
        '';
      };
    };
  };
}
