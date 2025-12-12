{ lib, pkgs, inputs, ... }:
let
  username = "sunghyun";
  homeDir = "/home/${username}";
  onePassAgent = "${homeDir}/.1password/agent.sock";
in {
  imports = [
    ./fcitx5.nix
    ./packages.nix
    ./thunderbird.nix
    ./timewall.nix
    ./gnome.nix
  ];

  dconf.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "25.11";
  services.mpris-proxy.enable = true;

  home.language = {
    base = "en_US.UTF-8";
    address = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    time = "en_US.UTF-8";
  };

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
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        search_mode = "fuzzy";
        filter_mode = "global";
        update_check = false;
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "podman" "npm" "sudo" "command-not-found" ];
      };
      initContent = ''
        fastfetch && if [ "$(pwd)" = "${homeDir}" ]; then cd ~/Documents; fi
      '';
      shellAliases = {
        build =
          "cd ~/Documents/nix && nixfmt **/*.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#framework --impure && ngc";
        nixgit = ''
          cd ~/Documents/nix && git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
        ec = "expressvpn connect";
        ed = "expressvpn disconnect";
        x = "exit";
        oo = "hub browse";
        zz = "antigravity ~/Documents/nix";
        ss = "source ~/.zshrc";
        cc = "antigravity .";
        sha =
          "git push && echo Done in $(git rev-parse HEAD) | xclip -selection clipboard";
        emptyfolder = "find . -type d -empty -delete";
        npm = "bun";
        npx = "bunx";
        chat = "codex --yolo -c model_reasoning_effort='high'";
        ngc =
          "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +20 && sudo nix-store --gc";
        airdrop =
          "cd ~/Screenshots && sudo tailscale file cp *.png iphone-17-pro: && rm *.png";
      };
    };
    git = {
      enable = true;
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      settings = {
        user = {
          name = "Sunghyun Cho";
          email = "hey@cho.sh";
        };
        core = { editor = "cursor --wait"; };
        credential = { helper = "${lib.getExe pkgs.gh} auth git-credential"; };
        gpg = { format = "ssh"; };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = { gpgsign = true; };
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          identityAgent = onePassAgent;
        };
      };
    };
  };

  xdg.configFile."autostart/1password.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=${pkgs._1password-gui}/bin/1password --silent
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name=1Password
    Comment=Password manager and secure wallet
  '';

  xdg.configFile."1password/1password-bw-integration".text = "";
}
