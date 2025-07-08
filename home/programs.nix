{ config, pkgs, inputs, ... }:

{
  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "docker" "npm" ];
      };
      initContent = ''
        ${pkgs.fastfetch}/bin/fastfetch
      '';
    };

  };
}
