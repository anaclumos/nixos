{ config, lib, pkgs, ... }:

let
  berkeleyMono =
    pkgs.callPackage ../../fonts/berkeley-mono/berkeley-mono.nix { };
in {
  fonts.packages = with pkgs; [ pretendard berkeleyMono ];
  fonts.fontDir.enable = true;
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Pretendard" ];
      serif = [ "Pretendard" ];
      monospace = [ "Berkeley Mono" ];
    };
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <!-- Replace various fonts with Pretendard -->
        <alias>
          <family>Helvetica</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Helvetica Neue</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Arial</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>-apple-system</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>BlinkMacSystemFont</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Ubuntu</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>noto-sans</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>malgun gothic</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Apple SD Gothic Neo</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>AppleSDGothicNeo</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Noto Sans TC</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Noto Sans JP</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Noto Sans KR</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Noto Sans</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Roboto</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>Tahoma</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>맑은 고딕</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>MalgunGothic</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
        <alias>
          <family>돋움</family>
          <prefer><family>Pretendard</family></prefer>
        </alias>
      </fontconfig>
    '';
  };
}
