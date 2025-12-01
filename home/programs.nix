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
        plugins = [ "git" "podman" "npm" ];
      };
      initContent = ''
        ${pkgs.fastfetch}/bin/fastfetch && if [ "$(pwd)" = "/home/sunghyun" ]; then cd ~/Documents; fi
      '';
      shellAliases = {
        npm = "bun";
        npx = "bunx";
      };
    };

  };
}
