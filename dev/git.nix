{ config, lib, pkgs, ... }:

{
  # Home Manager configuration for git
  home-manager.users.sunghyun = {
    programs.git = {
      enable = true;
      userName = "Sunghyun Cho";
      userEmail = "hey@cho.sh";

      # Git signing configuration with 1Password SSH
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };

      extraConfig = {
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
