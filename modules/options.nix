{ config, lib, pkgs, ... }:
with lib;
let
  sysCfg = config.modules.system;
  userCfg = config.modules.user;
in {
  options.modules = {
    system = {
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
    user = {
      name = mkOption {
        type = types.str;
        default = "sunghyun";
        description = "Primary user name";
      };
      fullName = mkOption {
        type = types.str;
        default = "Sunghyun Cho";
        description = "User's full name";
      };
      shell = mkOption {
        type = types.package;
        default = pkgs.zsh;
        description = "Default shell for the user";
      };
      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ "wheel" "networkmanager" "docker" "video" "audio" ];
        description = "Additional groups for the user";
      };
    };
  };

  config = {
    networking.hostName = sysCfg.hostname;
    time.timeZone = sysCfg.timezone;
    i18n.defaultLocale = sysCfg.locale;

    services.fprintd.enable = sysCfg.enableFingerprint;

    hardware.bluetooth = mkIf sysCfg.enableBluetooth {
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

    users.users.${userCfg.name} = {
      isNormalUser = true;
      description = userCfg.fullName;
      extraGroups = userCfg.extraGroups;
      shell = userCfg.shell;
    };
  };
}
