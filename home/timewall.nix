{ config, pkgs, ... }:

{
  systemd.user.services.timewall = {
    Unit = {
      Description = "Timewall - Dynamic HEIF wallpaper daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart =
        "${pkgs.timewall}/bin/timewall set --daemon '${./solar-gradient.heic}'";
      Restart = "always";
      RestartSec = "10";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  xdg.configFile."timewall/config.toml" = {
    text = ''
      [location]
      lat = 37.5665
      lon = 126.9780
    '';
    force = true;
  };
}
