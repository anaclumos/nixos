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
          capslock = overload(hyper, f19)

          # Bind Alt keys to trigger the 'meta_mac' layer (acting as Command)
          leftalt = layer(meta_mac)

          # Remap Super/Windows keys to act as Alt for word navigation
          leftmeta = layer(alt_layer)
          rightmeta = layer(alt_layer)


          # By default meta_mac = Ctrl+<key>, except for mappings below
          [meta_mac:C]
          # Use alternate Copy/Cut/Paste bindings from Windows that won't conflict with Ctrl+C used to break terminal apps
          # Copy (works everywhere (incl. vscode cursor term) except Konsole)
          c = C-insert
          # Paste
          v = S-insert
          # Cut
          x = S-delete


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

          # Move cursor to the beginning of the line
          left = home
          # Move cursor to the end of the line
          right = end

          # As soon as 'tab' is pressed (but not yet released), switch to the 'app_switch_state' overlay
          tab = swapm(app_switch_state, A-tab)

          [app_switch_state:A]
          # Being in this state holds 'Alt' down allowing us to switch back and forth with tab or arrow presses

          [meta_fn:M]
          # Left control + function key layer - map arrow keys to workspace switching
          left = M-home
          right = M-end
          up = M-pageup
          down = M-pagedown

          [alt_layer:A]
          # Alt layer for word navigation and deletion
          # Alt + Left/Right for word navigation
          left = C-left
          right = C-right
          # Alt + Delete for word deletion
          delete = C-delete

          [hyper:C-A-S-M]
        '';
      };
    };
  };
}
