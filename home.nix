{ config, pkgs, inputs, ... }:

{
  imports = [ inputs._1password-shell-plugins.hmModules.default ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sunghyuncho";
  home.homeDirectory = "/home/sunghyuncho";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    vscode
    google-chrome
    gitAndTools.hub
    spotify
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
    (lib.hiPrio windsurf)
  ];

  programs._1password-shell-plugins = {
    # enable 1Password shell plugins for bash, zsh, and fish shell
    enable = true;
    # the specified packages as well as 1Password CLI will be
    # automatically installed and configured to use shell plugins
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
    };

    initExtra = ''
      export SSH_AUTH_SOCK=~/.1password/agent.sock
      mkdir -p ~/.config/autostart \
        && cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ~/.config/autostart/gnome-keyring-ssh.desktop \
        && echo "Hidden=true" >> ~/.config/autostart/gnome-keyring-ssh.desktop
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

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
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
}
