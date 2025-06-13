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
        # Run Fastfetch on terminal start
        ${pkgs.fastfetch}/bin/fastfetch
      '';
    };

  };

  xdg.desktopEntries.kakaotalk = {
    name = "KakaoTalk";
    genericName = "Messenger";
    exec = "${inputs.kakaotalk.packages.x86_64-linux.default}/bin/kakaotalk";
    icon = "kakaotalk";
    categories = [ "Network" "InstantMessaging" ];
    comment = "KakaoTalk Messenger";
  };
}
