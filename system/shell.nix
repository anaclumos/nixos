{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "podman" "npm" "sudo" "command-not-found" ];
    };
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
}
