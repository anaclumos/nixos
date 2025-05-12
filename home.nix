{ config, pkgs, inputs, ... }:

{
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    gitAndTools.hub
    asdf-vm
    nodejs
    nodePackages.pnpm
    bun
    nixfmt-classic
    claude-code
    slack
    obsidian
    ibus
    ibus-engines.hangul
    google-chrome
    windsurf
    adwaita-icon-theme
    hicolor-icon-theme
    adguardhome
    xclip
    fastfetch
    tailscale
    bottles
    steam
    google-cloud-sdk
    pretendard
  ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh awscli2 ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "npm" "sudo" "command-not-found" ];
    };

    shellAliases = {
      rebuild =
        "cd ~/Desktop/nixos && nixfmt *.nix && nix-channel --update && nix flake update && sudo nixos-rebuild switch --flake .#spaceship";
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      qqqq = "cd ~/Desktop/extracranial && bun run save";
      x = "exit";
    };

    initContent = ''
      if [ -f ~/.config/op/plugins.sh ]; then
        source ~/.config/op/plugins.sh
      fi
      export SSH_AUTH_SOCK=~/.1password/agent.sock
      if [ -z "$(ssh-add -l 2>/dev/null)" ]; then
        op signin
      fi
      command -v fastfetch >/dev/null 2>&1 && fastfetch
    '';
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
      AddKeysToAgent yes
    '';
  };

  programs.git = {
    enable = true;
    userName = "Sunghyun Cho";
    userEmail = "hey@cho.sh";
    signing = {
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      commit.gpgsign = true;
    };
  };

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Pretendard" ];
    serif = [ "Pretendard" ];
  };

  home.activation.updateGTKIconCache = {
    after = [ "writeBoundary" "linkGeneration" ];
    before = [ ];
    data = "gtk-update-icon-cache -qtf ~/.local/share/icons/* || true";
  };

  xdg.configFile."fontconfig/conf.d/99-pretendard-substitutions.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica Neue</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Arial</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Tahoma</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Verdana</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>-apple-system</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>BlinkMacSystemFont</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Noto Sans</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Ubuntu</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Roboto</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Nanum Gothic</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Malgun Gothic</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Apple SD Gothic Neo</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Dotum</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>Gulim</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>
    </fontconfig>
  '';

}
