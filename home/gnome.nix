{ pkgs, ... }:

{
  # GNOME Shell CSS customization
  home.file.".config/gtk-3.0/gtk.css".text = ''
    /* Reduce spacing between extension icons in the top panel */
    #panel .panel-button {
      -natural-hpadding: 4px !important;
      -minimum-hpadding: 2px !important;
      padding: 0 4px !important;
    }

    /* Reduce spacing for system indicators */
    #panel .system-status-icon {
      margin: 0 2px !important;
      padding: 0 2px !important;
    }

    /* Reduce spacing for app indicators */
    #panel .app-menu-icon {
      margin: 0 2px !important;
      padding: 0 2px !important;
    }

    /* AppIndicator extension specific */
    #panel .appindicator-icon-panel {
      padding: 0 2px !important;
      margin: 0 2px !important;
    }
  '';

  # Custom GNOME Shell theme
  home.file.".local/share/themes/custom-compact/gnome-shell/gnome-shell.css".text =
    ''
      /* Import default theme */
      @import url("/usr/share/gnome-shell/theme/gnome-shell.css");

      /* Reduce panel button spacing */
      #panel .panel-button {
        -natural-hpadding: 4px !important;
        -minimum-hpadding: 2px !important;
        padding-left: 4px !important;
        padding-right: 4px !important;
      }

      /* Reduce spacing in status area */
      #panel .panel-status-indicators-box,
      #panel .panel-status-menu-box {
        spacing: 4px !important;
      }

      /* AppIndicator specific */
      #panel .appindicator-container {
        spacing: 4px !important;
      }

      #panel .appindicator-icon {
        padding: 0 2px !important;
      }
    '';

  # Enable custom theme
  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = { name = "custom-compact"; };
  };

  dconf.settings."org/gnome/desktop/input-sources" = {
    sources = "[('xkb','us'), ('ibus','hangul')]";
    mru-sources = "[('xkb','us'), ('ibus','hangul')]";
    per-window = false;
  };
}
