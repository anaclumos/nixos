{ config, pkgs, inputs, ... }: {
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fastfetch = {
      enable = true;
      settings = {
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "battery"
          "poweradapter"
          "locale"
          "break"
          "colors"
        ];
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "podman" "npm" ];
      };
      initContent = ''
        fastfetch && if [ "$(pwd)" = "/home/sunghyun" ]; then cd ~/Documents; fi
      '';
      shellAliases = {
        npm = "bun";
        npx = "bunx";
      };
    };
  };
}
