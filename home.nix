{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs._1password-shell-plugins.hmModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";
  home.stateVersion = "24.11";

  # Configure cursor theme to fix white box cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  # Configure Pantheon settings
  dconf.settings = {
    "org/pantheon/desktop/interface" = {
      clock-format = "12h";
      cursor-theme = "Adwaita";
      cursor-size = 24;
    };
  };

  home.packages = with pkgs; [
    git
    gitAndTools.hub
    asdf-vm
    nodejs
    pkgs.claude-code
    nodePackages.pnpm
    slack
    ibus
    ibus-engines.hangul
    windsurf
    obsidian
    google-chrome
    steam
    adguardhome
    xclip
    fastfetch
    bun
    nixfmt-classic
    pkgs.adwaita-icon-theme
  ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh awscli2 ];
  };

  # Configure zsh with home-manager
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
        "cd ~/etc/nixos && sudo nix-channel --update && sudo nix flake update && sudo nixos-rebuild switch --upgrade --flake .#spaceship";
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a && git push'';
      llm = ''
        find . -type f ! -path "*/.git/*" ! -name "*.lock*" ! -name "*lock.*" -exec grep -Iq . {} \; -and -exec sh -c 'echo -e "### $(basename $1)\n\n\`\`\`\n$(cat $1)\n\`\`\`\n\n"' sh {} \; | xclip -selection clipboard'';
    };

    initExtra = ''
      # Source 1Password plugins
      source ~/.config/op/plugins.sh

      # Ensure 1Password SSH agent is used
      export SSH_AUTH_SOCK=~/.1password/agent.sock

      # Add SSH identities to 1Password agent
      if [ -z "$(ssh-add -l 2>/dev/null)" ]; then
        op signin
      fi


      # Run fastfetch on terminal start
      command -v fastfetch >/dev/null 2>&1 && fastfetch
    '';
  };

  # Enhanced SSH configuration
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
      AddKeysToAgent yes
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git configuration
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

  # Add Pretendard font to your system
  fonts.fontconfig.enable = true;

  # Configure font substitutions
  xdg.configFile."fontconfig/conf.d/99-pretendard-substitutions.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Replace Helvetica with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Helvetica Neue with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Helvetica Neue</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Arial with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Arial</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Helvetica with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>-apple-system</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace BlinkMacSystemFont with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>BlinkMacSystemFont</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>

      <!-- Replace Ubuntu with Pretendard -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Ubuntu</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Pretendard</string>
        </edit>
      </match>
    </fontconfig>
  '';

  # Flatpak configuration
  services.flatpak = {
    enable = true;
    packages = [
      # Keep only those that don't have good Nix alternatives
      "app.bluebubbles.BlueBubbles"
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
      # bottles
      "com.usebottles.bottles"
    ];
  };
}
