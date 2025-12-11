{ lib, config, ... }:
with lib;
let cfg = config.modules.system;
in {
  options.modules.system = {
    hostname = mkOption {
      type = types.str;
      default = "framework";
      description = "System hostname";
    };
    timezone = mkOption {
      type = types.str;
      default = "Asia/Seoul";
      description = "System timezone";
    };
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };
    enableBluetooth = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bluetooth support";
    };
    enableFingerprint = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fingerprint reader support";
    };
  };

  config = {
    networking.hostName = cfg.hostname;
    time.timeZone = cfg.timezone;
    i18n.defaultLocale = cfg.locale;

    services.fprintd.enable = cfg.enableFingerprint;

    hardware.bluetooth = mkIf cfg.enableBluetooth {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };
  };
}
