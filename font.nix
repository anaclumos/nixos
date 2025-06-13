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
      </fontconfig>
    '';
  };
}
