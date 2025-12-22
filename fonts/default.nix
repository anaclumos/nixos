{ lib, pkgs, ... }:
let
  fontAliases = [
    "Helvetica"
    "Helvetica Neue"
    "Arial"
    "-apple-system"
    "BlinkMacSystemFont"
    "Ubuntu"
    "noto-sans"
    "malgun gothic"
    "Apple SD Gothic Neo"
    "AppleSDGothicNeo"
    "Noto Sans TC"
    "Noto Sans JP"
    "Noto Sans KR"
    "Noto Sans"
    "Roboto"
    "Tahoma"
    "맑은 고딕"
    "맑은고딕"
    "MalgunGothic"
    "돋움"
  ];

  generateFontAlias = font: ''
    <match target="pattern">
      <test qual="any" name="family">
        <string>${font}</string>
      </test>
      <edit name="family" mode="assign" binding="same">
        <string>Pretendard GOV</string>
      </edit>
    </match>
  '';

  berkeleyMono = pkgs.stdenv.mkDerivation {
    pname = "berkeley-mono";
    version = "2025-07-02";
    src = ./berkeley-mono.zip;
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    installPhase = ''
      install -Dm644 *.otf -t $out/share/fonts/opentype
    '';
    meta = {
      description = "Berkeley Mono type family";
      license = lib.licenses.unfreeRedistributable;
      platforms = lib.platforms.all;
    };
  };
in {
  fonts.packages = with pkgs; [
    pretendard-gov
    monaspace
    berkeleyMono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  fonts.fontDir.enable = true;
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Pretendard GOV" "Noto Sans CJK KR" ];
      serif = [ "Pretendard GOV" "Noto Serif CJK KR" ];
      monospace = [ "Monaspace" ];
    };
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <!-- Replace various fonts with Pretendard GOV -->
        ${lib.concatMapStrings generateFontAlias fontAliases}
      </fontconfig>
    '';
  };
}
