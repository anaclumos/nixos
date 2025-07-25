{ lib, ... }:

with lib;

{
  options.modules.system = {
    hostname = mkOption {
      type = types.str;
      default = "cho";
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

    enableSteam = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Steam gaming platform";
    };

    enableFingerprint = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fingerprint reader support";
    };
  };
}
