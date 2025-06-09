{ config, pkgs, ... }:

{
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Sunghyun Cho";
      userEmail = "hey@cho.sh";
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "docker" "npm" ];
      };
      initContent = ''
        # Run Fastfetch on terminal start
        ${pkgs.fastfetch}/bin/fastfetch
      '';
    };
  };
}