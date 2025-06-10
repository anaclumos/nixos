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
      export XDG_DATA_HOME="''${HOME:-$HOME}/.local/share"
      if ! bottles-cli list | grep -qx Windows; then
        bottles-cli create --name Windows --type gaming
      fi
      install -Dm444 ${winPayload}/share/winapp/WinAppInstaller.exe \
        "$XDG_DATA_HOME/bottles/downloads/WinAppInstaller.exe"
    '';
  };

  # launcher script that runs KakaoTalk
  kakaoLauncher = pkgs.writeShellApplication {
    name = "launch-kakaotalk";
    runtimeInputs = [ pkgs.bottles ];
    text = ''
      bottles-cli run -b Windows -e "C:\\Program Files\\KakaoTalk\\KakaoTalk.exe"
    '';
  };

  # desktop shortcut that launches KakaoTalk
  winAppDesktop = pkgs.makeDesktopItem {
    name         = "KakaoTalk";
    desktopName  = "KakaoTalk";
    exec         = "${kakaoLauncher}/bin/launch-kakaotalk";
    icon         = "application-x-executable";
    categories   = [ "Network" "InstantMessaging" ];
  };
in
{
  environment.systemPackages = [
    pkgs.bottles
    winPayload
    prepareBottle
    kakaoLauncher
    winAppDesktop
  ];
}