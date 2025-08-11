{ config, pkgs, ... }:

let
  tb = pkgs.thunderbird; # or pkgs.betterbird
  tb-ui = pkgs.writeShellScriptBin "thunderbird-ui" ''
    systemctl --user stop thunderbird-headless.service 2>/dev/null || true
    "${tb}/bin/thunderbird" "$@"
    systemctl --user start thunderbird-headless.service
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
      ExecStart = "${tb}/bin/thunderbird --headless";
      Restart = "on-failure";
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
