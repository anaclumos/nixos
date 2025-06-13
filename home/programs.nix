{ config, pkgs, ... }:

{
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Sunghyun Cho";
      userEmail = "hey@cho.sh";
      signing = {
        signByDefault = true;
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      };
    };

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

    # Enable 1Password GUI to start on login
    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui;
    };

  };

  # Autostart 1Password on login
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
}
