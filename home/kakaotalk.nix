{
  pkgs ? import <nixpkgs> {},
  wineprefix ? "",
  winearch ? "win32",
  fonts ? "corefonts cjkfonts",
}:

let
  exe = pkgs.fetchurl {
    url = https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe;
    sha256 = "1kg2m506g10lmg35iz30qfnszxhja7c0v5xr9gi81c4fkq625z1p";
  };
in

with pkgs;

stdenv.mkDerivation {
  name = "kakaotalk";
  src = ./.;
  buildInputs = [
    wineWowPackages.full
    winetricks
  ];
  shellHook = ''
    PREFIX=${wineprefix}
    if [[ -z "${wineprefix}" ]]; then
      PREFIX=$(mktemp -d)
      echo PREFIX="$PREFIX"
    fi
    echo Install kakaotalk from ${exe}...
    if [[ -z "${fonts}" ]]; then
      echo Skip winetricks
    else
      WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} winetricks ${fonts}
    fi
    WINEPREFIX=$PREFIX WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=${winearch} wine ${exe}
  '';
}