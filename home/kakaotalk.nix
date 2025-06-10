{ config, pkgs, ... }:

let
  kakaotalk = pkgs.stdenv.mkDerivation {
    name = "kakaotalk";
    src = pkgs.fetchurl {
      url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
      sha256 = "1kg2m506g10lmg35iz30qfnszxhja7c0v5xr9gi81c4fkq625z1p";
    };
    nativeBuildInputs = with pkgs; [
      wineWowPackages.full
      winetricks
    ];
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/KakaoTalk_Setup.exe
      cat > $out/bin/kakaotalk << EOF
      #!/bin/sh
      PREFIX=\''${WINEPREFIX:-\$(mktemp -d)}
      echo "Installing KakaoTalk from $out/bin/KakaoTalk_Setup.exe..."
      WINEPREFIX=\$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=win32 ${pkgs.winetricks}/bin/winetricks corefonts cjkfonts
      WINEPREFIX=\$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=win32 ${pkgs.wineWowPackages.full}/bin/wine $out/bin/KakaoTalk_Setup.exe
      EOF
      chmod +x $out/bin/kakaotalk
    '';
  };
in

{
  home.packages = [ kakaotalk ];
}