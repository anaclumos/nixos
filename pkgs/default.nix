{ pkgs, lib, ... }:

let
  # binary fetch + hash verification
  winInstaller = pkgs.fetchurl {
    url    = "https://app-pc.kakaocdn.net/talk/win32/under_win10/KakaoTalk_Setup.exe";
    sha256 = lib.fakeSha256;
  };

  # fixed-output derivation holding the installer
  winPayload = pkgs.stdenv.mkDerivation {
    name       = "winapp-payload";
    src        = winInstaller;
    dontBuild  = true;
    installPhase = ''
      install -Dm444 "$src" "$out/share/winapp/WinAppInstaller.exe"
    '';
  };

  # one-shot script: create bottle "Windows", drop installer
  prepareBottle = pkgs.writeShellApplication {
    name = "prepare-windows-bottle";
    runtimeInputs = [ pkgs.bottles ];
    text = ''
      set -e
      export XDG_DATA_HOME="${HOME}/.local/share"
      if ! bottles-cli list | grep -qx Windows; then
        bottles-cli create --name Windows --type gaming
      fi
      install -Dm444 ${winPayload}/share/winapp/WinAppInstaller.exe \
        "$XDG_DATA_HOME/bottles/downloads/WinAppInstaller.exe"
    '';
  };

  # desktop shortcut that launches the program inside the bottle
  winAppDesktop = pkgs.makeDesktopItem {
    name         = "Windows-App";
    desktopName  = "Windows App";
    exec         = "bottles-cli run -b Windows -e \"C:\\\\Program Files\\\\WinApp\\\\WinApp.exe\"";
    icon         = "application-x-executable"; # substitute custom icon path if present
    categories   = [ "Utility" ];
  };
in
{
  environment.systemPackages = [
    pkgs.bottles
    winPayload
    prepareBottle
    winAppDesktop
  ];

  # trigger bottle preparation on each rebuild (omit if undesired)
  system.activationScripts.prepareBottle.text = ''
    ${prepareBottle}/bin/prepare-windows-bottle
  '';
}