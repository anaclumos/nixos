{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs._1password-shell-plugins.hmModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    gitAndTools.hub
    asdf-vm
    _1password-gui
    _1password-cli
    gh
    nodejs
    pkgs.claude-code
    nodePackages.pnpm
    slack
    ibus
    ibus-engines.hangul
    nixfmt-classic
    warp-terminal
    dconf-editor
    flatpak
    gnome-tweaks
    (lib.hiPrio windsurf)
    obsidian
    google-chrome
    steam
    spotify
    libreoffice
    bottles
    gnome-extension-manager
    adguardhome
    beeper
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
      rebuild = ''
        find . -name "*.nix" -type f | xargs nixfmt && sudo nix flake update && sudo nixos-rebuild switch'';
      nixgit = ''git commit -m "$(date +"%Y-%m-%d")" -a & git push'';
    };

    initExtra = ''
      # Ensure 1Password SSH agent is used
      export SSH_AUTH_SOCK=~/.1password/agent.sock

      # Add SSH identities to 1Password agent
      if [ -z "$(ssh-add -l 2>/dev/null)" ]; then
        op signin
      fi
    '';
  };

  # Enhanced SSH configuration
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
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
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
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
    ];
  };
}
