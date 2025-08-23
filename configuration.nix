{ config, pkgs, lib, ... }:

let
  user = "sunghyun";
  hostname = "cho";

in {
  nixpkgs.config.allowUnfree = true;
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

  # Graphics configuration for Steam and games
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.fw-fanctrl.enable = true;

  # fw-fanctrl: use a local config and avoid battery sensor errors
  environment.etc."fw-fanctrl/config.json".text = ''
    {
      "$schema": "./config.schema.json",
      "defaultStrategy": "lazy",
      "strategies": {
        "aeolus": {
          "fanSpeedUpdateFrequency": 2,
          "movingAverageInterval": 5,
          "speedCurve": [
            { "speed": 20, "temp": 0 },
            { "speed": 50, "temp": 40 },
            { "speed": 100, "temp": 65 }
          ]
        },
        "agile": {
          "fanSpeedUpdateFrequency": 3,
          "movingAverageInterval": 15,
          "speedCurve": [
            { "speed": 15, "temp": 0 },
            { "speed": 15, "temp": 40 },
            { "speed": 30, "temp": 60 },
            { "speed": 40, "temp": 70 },
            { "speed": 80, "temp": 75 },
            { "speed": 100, "temp": 85 }
          ]
        },
        "deaf": {
          "fanSpeedUpdateFrequency": 2,
          "movingAverageInterval": 5,
          "speedCurve": [
            { "speed": 20, "temp": 0 },
            { "speed": 30, "temp": 40 },
            { "speed": 50, "temp": 50 },
            { "speed": 100, "temp": 60 }
          ]
        },
        "laziest": {
          "fanSpeedUpdateFrequency": 5,
          "movingAverageInterval": 40,
          "speedCurve": [
            { "speed": 0, "temp": 0 },
            { "speed": 0, "temp": 45 },
            { "speed": 25, "temp": 65 },
            { "speed": 35, "temp": 70 },
            { "speed": 50, "temp": 75 },
            { "speed": 100, "temp": 85 }
          ]
        },
        "lazy": {
          "fanSpeedUpdateFrequency": 5,
          "movingAverageInterval": 30,
          "speedCurve": [
            { "speed": 15, "temp": 0 },
            { "speed": 15, "temp": 50 },
            { "speed": 25, "temp": 65 },
            { "speed": 35, "temp": 70 },
            { "speed": 50, "temp": 75 },
            { "speed": 100, "temp": 85 }
          ]
        },
        "medium": {
          "fanSpeedUpdateFrequency": 5,
          "movingAverageInterval": 30,
          "speedCurve": [
            { "speed": 15, "temp": 0 },
            { "speed": 15, "temp": 40 },
            { "speed": 30, "temp": 60 },
            { "speed": 40, "temp": 70 },
            { "speed": 80, "temp": 75 },
            { "speed": 100, "temp": 85 }
          ]
        },
        "very-agile": {
          "fanSpeedUpdateFrequency": 2,
          "movingAverageInterval": 5,
          "speedCurve": [
            { "speed": 15, "temp": 0 },
            { "speed": 15, "temp": 40 },
            { "speed": 30, "temp": 60 },
            { "speed": 40, "temp": 70 },
            { "speed": 80, "temp": 75 },
            { "speed": 100, "temp": 85 }
          ]
        }
      },
      "strategyOnDischarging": ""
    }
  '';

  # Add --no-battery-sensors and use the /etc config
  systemd.services.fw-fanctrl.serviceConfig = {
    ExecStart = lib.mkForce ''
      ${pkgs.fw-fanctrl}/bin/fw-fanctrl --output-format JSON run \
        --config /etc/fw-fanctrl/config.json \
        --silent \
        --no-battery-sensors
    '';
    ExecStopPost = lib.mkForce ''
      ${pkgs.fw-ectool}/bin/ectool autofanctrl
    '';
  };

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  environment.systemPackages = with pkgs; [ ];

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
