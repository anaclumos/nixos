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

          leftalt = layer(meta_mac)
          rightalt = rightcontrol

          # Remap Super/Windows keys to act as Alt for word navigation
          leftmeta = layer(alt_layer)
          rightmeta = layer(alt_layer)

          # Delete entire line — Left Control + Delete
          # TODO: This is not working.

          # By default meta_mac = Ctrl+<key>, except for mappings below
          [meta_mac:C]
          # Copy / Paste / Cut
          c = C-insert
          v = S-insert
          x = S-delete

          # Delete word — Left Alt + Delete
          # TODO: This is not working.

          # Switch directly to an open tab (e.g., Firefox, VS Code)
          1 = A-1
          2 = A-2
          3 = A-3
          4 = A-4
          5 = A-5
          6 = A-6
          7 = A-7
          8 = A-8
          9 = A-9

          # Move cursor to the beginning/end of the line
          left = home
          right = end

          # As soon as 'tab' is pressed (but not yet released), switch to the 'app_switch_state' overlay
          tab = swapm(app_switch_state, A-tab)

          [app_switch_state:A]
          # Holds 'Alt' down, allowing tab or arrow presses for app-switching

          [meta_fn:M]
          # Left Control + function-key layer — workspace switching
          left = M-home
          right = M-end
          up = M-pageup
          down = M-pagedown

          [alt_layer:A]
          # Alt layer for word navigation and deletion (for Super/Windows key)
          left = C-left
          right = C-right
          delete = C-delete

          [hyper:C-A-S-M]
        '';
      };
    };
  };
}
