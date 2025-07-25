{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.user;
in {
  options.modules.user = {
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

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups = cfg.extraGroups;
      shell = cfg.shell;
    };
  };
}
