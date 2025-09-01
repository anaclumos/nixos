{ config, lib, pkgs, ... }:

{
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
        "cd ~/Desktop/nix/os && nixfmt **/*.nix && nix-channel --update && nix --extra-experimental-features 'nix-command flakes' flake update && sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#cho --impure";
      nixgit = ''
        cd ~/Desktop/nix/os && git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      qq = "cd ~/Desktop/extracranial";
      qqqq = "cd ~/Desktop/extracranial && bun run save && gp && exit";
      ec = "expressvpn connect";
      ed = "expressvpn disconnect";
      x = "exit";
      oo = "hub browse";
      zz = "cursor ~/Desktop/nix";
      ss = "source ~/.zshrc";
      cc = "cursor .";
      sha =
        "git push && echo Done in $(git rev-parse HEAD) | xclip -selection clipboard";
      hn = "sh ~/Desktop/tools/hn/hn.sh";
      emptyfolder = "find . -type d -empty -delete";
      npm = "bun";
      npx = "bunx";
      chat =
        "codex --dangerously-bypass-approvals-and-sandbox --model gpt-5 -c model_reasoning_effort='high'";
      ngc =
        "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5 && sudo nix-store --gc";
    };
  };
}
