{ config, pkgs, lib, inputs, ... }:

let
  user = "sunghyun";
  hostname = "cho";

in {
  nixpkgs.config.allowUnfree = true;
  # Use the upstream fw-fanctrl flake’s pinned package to satisfy jsonschema constraints
  nixpkgs.overlays = [
    (final: prev: {
      fw-fanctrl = inputs.fw-fanctrl.packages.x86_64-linux.fw-fanctrl;
    })
  ];
  imports = [
    ./hardware-configuration.nix
    ./gnome/default.nix
    ./system/default.nix
    ./dev/default.nix
    ./modules/user.nix
    ./modules/config.nix
  ];

  # Module configuration
  modules.user.name = user;
  modules.system.hostname = hostname;
  modules.system.timezone = "Asia/Seoul";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.fprintd.enable = true;

  services.fwupd.enable = true;

  services.expressvpn.enable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-hangul fcitx5-gtk ];
    };
  };

  services.tailscale.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.printing.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

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
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            {
              temp = 0;
              speed = 15;
            }
            {
              temp = 100;
              speed = 15;
            }
          ];
        };

        # Normal: Approximate Framework's default policy using the built-in "medium" curve.
        Normal = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
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

        # Full-Blast: Aggressive full-speed operation.
        Full-Blast = {
          fanSpeedUpdateFrequency = 2;
          movingAverageInterval = 5;
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
    strategies = {
      Silent = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 100;
            speed = 15;
          }
        ];
      };
      Normal = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
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
      Full-Blast = {
        fanSpeedUpdateFrequency = 2;
        movingAverageInterval = 5;
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

  environment.systemPackages = with pkgs; [
    inputs.fw-fanctrl.packages.x86_64-linux.fw-fanctrl
    fw-ectool
  ];

  environment.variables = {
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "0";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  system.stateVersion = "25.05";
}
