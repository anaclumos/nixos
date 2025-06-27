{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [ pretendard ];
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Pretendard" ];
      serif = [ "Pretendard" ];
    };
    localConf = ''
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

        <!-- Replace -apple-system with Pretendard -->
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

        <!-- Replace noto-sans with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>noto-sans</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace 'malgun gothic' with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>malgun gothic</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Apple SD Gothic Neo with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Apple SD Gothic Neo</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace AppleSDGothicNeo with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>AppleSDGothicNeo</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Noto Sans TC with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Noto Sans TC</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Noto Sans JP with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Noto Sans JP</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Noto Sans KR with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Noto Sans KR</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Noto Sans with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Noto Sans</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Roboto with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Roboto</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>

        <!-- Replace Tahoma with Pretendard -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>Tahoma</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>Pretendard</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };
}
