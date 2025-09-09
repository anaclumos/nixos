{ config, lib, pkgs, ... }:

let
  berkeleyMono =
    pkgs.callPackage ../../fonts/berkeley-mono/berkeley-mono.nix { };

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
    "MalgunGothic"
    "돋움"
  ];

  generateFontAlias = font: ''
    <match target="pattern">
      <test qual="any" name="family">
        <string>${font}</string>
      </test>
      <edit name="family" mode="assign" binding="same">
        <string>Pretendard</string>
      </edit>
    </match>
  '';
in {
  fonts.packages = with pkgs; [ pretendard monaspace berkeleyMono ];
  fonts.fontDir.enable = true;
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Pretendard" ];
      serif = [ "Pretendard" ];
      monospace = [ "Monaspace" ];
    };
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <!-- Replace various fonts with Pretendard -->
        ${lib.concatMapStrings generateFontAlias fontAliases}
      </fontconfig>
    '';
  };
}
