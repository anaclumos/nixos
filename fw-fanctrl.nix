{ config, pkgs, inputs, ... }:

{
  # Framework Laptop fan control
  programs.fw-fanctrl = {
    enable =
      false; # use manual service below to avoid jsonschema mismatch in nixpkgs
    # Custom strategies per user request.
    # Note: strategy names cannot contain spaces per module schema.
    config = {
      defaultStrategy = "Normal";
      strategies = {
        # Silent: Always run at the lowest fan speed.
        Silent = {
          fanSpeedUpdateFrequency = 15;
          movingAverageInterval = 100;
          speedCurve = [
            {
              temp = 0;
              speed = 25;
            }
            {
              temp = 100;
              speed = 25;
            }
          ];
        };

        # Quiet: Always run at 50% fan speed.
        Quiet = {
          fanSpeedUpdateFrequency = 15;
          movingAverageInterval = 100;
          speedCurve = [
            {
              temp = 0;
              speed = 50;
            }
            {
              temp = 100;
              speed = 50;
            }
          ];
        };

        # Normal: Approximate Framework's default policy using the built-in "medium" curve.
        Normal = {
          fanSpeedUpdateFrequency = 10;
          movingAverageInterval = 90;
          speedCurve = [
            {
              temp = 0;
              speed = 15;
            }
            {
              temp = 40;
              speed = 15;
            }
            {
              temp = 60;
              speed = 30;
            }
            {
              temp = 70;
              speed = 40;
            }
            {
              temp = 75;
              speed = 80;
            }
            {
              temp = 85;
              speed = 100;
            }
          ];
        };

        # Faster: More aggressive than Normal, peaks faster
        Faster = {
          fanSpeedUpdateFrequency = 8;
          movingAverageInterval = 60;
          speedCurve = [
            {
              temp = 0;
              speed = 15;
            }
            {
              temp = 35;
              speed = 20;
            }
            {
              temp = 50;
              speed = 35;
            }
            {
              temp = 60;
              speed = 50;
            }
            {
              temp = 65;
              speed = 70;
            }
            {
              temp = 70;
              speed = 85;
            }
            {
              temp = 75;
              speed = 100;
            }
          ];
        };

        Blast = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 15;
          speedCurve = [
            {
              temp = 0;
              speed = 100;
            }
            {
              temp = 100;
              speed = 100;
            }
          ];
        };
      };
    };
  };

  # Manual fw-fanctrl service using upstream flake package
  environment.etc."fw-fanctrl/config.json".text = builtins.toJSON {
    defaultStrategy = "Normal";
    strategyOnDischarging = "Normal";
    strategies = {
      Silent = {
        fanSpeedUpdateFrequency = 10;
        movingAverageInterval = 100;
        speedCurve = [
          {
            temp = 0;
            speed = 25;
          }
          {
            temp = 100;
            speed = 25;
          }
        ];
      };
      Quiet = {
        fanSpeedUpdateFrequency = 10;
        movingAverageInterval = 100;
        speedCurve = [
          {
            temp = 0;
            speed = 50;
          }
          {
            temp = 100;
            speed = 50;
          }
        ];
      };
      Normal = {
        fanSpeedUpdateFrequency = 10;
        movingAverageInterval = 90;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 40;
            speed = 15;
          }
          {
            temp = 60;
            speed = 30;
          }
          {
            temp = 70;
            speed = 40;
          }
          {
            temp = 75;
            speed = 80;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };
      Faster = {
        fanSpeedUpdateFrequency = 8;
        movingAverageInterval = 60;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 35;
            speed = 20;
          }
          {
            temp = 50;
            speed = 35;
          }
          {
            temp = 60;
            speed = 50;
          }
          {
            temp = 65;
            speed = 70;
          }
          {
            temp = 70;
            speed = 85;
          }
          {
            temp = 75;
            speed = 100;
          }
        ];
      };
      Blast = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 15;
        speedCurve = [
          {
            temp = 0;
            speed = 100;
          }
          {
            temp = 100;
            speed = 100;
          }
        ];
      };
    };
  };

  systemd.services.fw-fanctrl = {
    description = "Framework Fan Controller (manual)";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart =
        "${inputs.fw-fanctrl.packages.x86_64-linux.fw-fanctrl}/bin/fw-fanctrl --output-format JSON run --config /etc/fw-fanctrl/config.json --silent";
      ExecStopPost = "${pkgs.fw-ectool}/bin/ectool autofanctrl";
    };
  };

  # Pause/resume on suspend
  environment.etc."systemd/system-sleep/fw-fanctrl-suspend.sh" = {
    text = ''
      #!${pkgs.bash}/bin/sh
      case "$1" in
          pre)  ${inputs.fw-fanctrl.packages.x86_64-linux.fw-fanctrl}/bin/fw-fanctrl pause ;;
          post) ${inputs.fw-fanctrl.packages.x86_64-linux.fw-fanctrl}/bin/fw-fanctrl resume ;;
      esac
    '';
    mode = "0755";
  };
}
