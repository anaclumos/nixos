# IBus Wayland configuration for KDE Plasma
{ config, pkgs, lib, ... }:

{
  # Ensure proper autostart for IBus Wayland in KDE Plasma
  environment.etc = {
    "xdg/autostart/org.freedesktop.IBus.Panel.Wayland.Gtk3.desktop" = {
      source =
        "${pkgs.ibus}/share/applications/org.freedesktop.IBus.Panel.Wayland.Gtk3.desktop";
      mode = "0644";
    };
  };

  # KDE-specific IBus Wayland settings
  # Use environment variables and autostart instead, since programs.ibus.panel doesn't exist
  environment.variables = {
    # Set IBus to use wayland panel
    IBUS_USE_PANEL_WAYLAND = "1";
  };

  # Additional guidance for the user:
  # Once system is rebuilt, open System Settings in KDE:
  # 1. Go to "Regional Settings" -> "Input Method"
  # 2. Ensure IBus is selected
  # 3. Click "Apply" 
  # 4. Log out and log back in
}
