{ config, lib, pkgs, ... }:

{
  # Home Manager configuration for git
  home-manager.users.sunghyun = {
    programs.git = {
      enable = true;

      # Git signing configuration with 1Password SSH
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };

      settings = {
        # User configuration
        user.name = "Sunghyun Cho";
        user.email = "hey@cho.sh";

        # Core configuration
        core.editor = "cursor --wait";

        # GPG configuration for SSH signing
        gpg = { format = "ssh"; };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = { gpgsign = true; };
      };
    };
  };
}
