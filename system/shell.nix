{ config, lib, pkgs, ... }:

{
  users.users.sunghyun = {
    isNormalUser = true;
    description = "Sunghyun Cho";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
    };

    shellAliases = {
      rebuild =
        "cd ~/Desktop/nixos && nixfmt **/*.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#cho --impure";
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      qqqq = "cd ~/Desktop/extracranial && bun run save";
      ec = "expressvpn connect";
      ed = "expressvpn disconnect";
      x = "exit";
      oo = "hub browse";
      zz = "cursor ~/Desktop/nixos";
      ss = "source ~/.zshrc";
      sha =
        "git push && echo Done in $(git rev-parse HEAD) | xclip -selection clipboard";
    };
  };
}
