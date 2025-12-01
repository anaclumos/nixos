{ config, pkgs, ... }:
let
  tb = pkgs.thunderbird;
  tb-ui = pkgs.writeShellScriptBin "thunderbird-ui" ''
    systemctl --user stop thunderbird-headless.service 2>/dev/null || true
    "${tb}/bin/thunderbird" "$@"
    systemctl --user start thunderbird-headless.service
  '';
  tb-headless-wrapper =
    pkgs.writeShellScriptBin "thunderbird-headless-wrapper" ''
      export DISPLAY=:0
      export WAYLAND_DISPLAY=wayland-0
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      ${pkgs.dbus}/bin/dbus-monitor --session "interface='org.freedesktop.Notifications',member='ActionInvoked'" | while read -r line; do
        if echo "$line" | grep -q "ActionInvoked"; then
          systemctl --user stop thunderbird-headless.service 2>/dev/null
          ${tb}/bin/thunderbird &
          sleep 2
          systemctl --user start thunderbird-headless.service
        fi
      done &
      MONITOR_PID=$!
      "${tb}/bin/thunderbird" --headless
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
