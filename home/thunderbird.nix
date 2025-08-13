{ config, pkgs, ... }:

let
  tb = pkgs.thunderbird; # or pkgs.betterbird
  tb-ui = pkgs.writeShellScriptBin "thunderbird-ui" ''
    systemctl --user stop thunderbird-headless.service 2>/dev/null || true
    "${tb}/bin/thunderbird" "$@"
    systemctl --user start thunderbird-headless.service
  '';

  # Wrapper that intercepts notifications and makes them clickable
  tb-headless-wrapper =
    pkgs.writeShellScriptBin "thunderbird-headless-wrapper" ''
      export DISPLAY=:0
      export WAYLAND_DISPLAY=wayland-0
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"

      # Start monitoring for notification clicks in background
      ${pkgs.dbus}/bin/dbus-monitor --session "interface='org.freedesktop.Notifications',member='ActionInvoked'" | while read -r line; do
        if echo "$line" | grep -q "ActionInvoked"; then
          # Open Thunderbird UI when notification is clicked
          systemctl --user stop thunderbird-headless.service 2>/dev/null
          ${tb}/bin/thunderbird &
          sleep 2
          systemctl --user start thunderbird-headless.service
        fi
      done &
      MONITOR_PID=$!

      # Run Thunderbird in headless mode
      "${tb}/bin/thunderbird" --headless

      # Clean up monitor on exit
      kill $MONITOR_PID 2>/dev/null || true
    '';
in {
  home.packages = [ tb tb-ui ];

  systemd.user.services.thunderbird-headless = {
    Unit = {
      Description =
        "Thunderbird headless (background mail checks + notifications)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${tb-headless-wrapper}/bin/thunderbird-headless-wrapper";
      Restart = "on-failure";
      Environment = [ "DISPLAY=:0" "WAYLAND_DISPLAY=wayland-0" ];
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  # Replace the default launcher to use our wrapper
  xdg.desktopEntries.thunderbird = {
    name = "Thunderbird";
    exec = "thunderbird-ui %u";
    terminal = false;
    icon = "thunderbird";
    type = "Application";
    categories = [ "Network" "Email" ];
    startupNotify = true;
  };
}
