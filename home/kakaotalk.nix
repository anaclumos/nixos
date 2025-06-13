{
  description = "A Nix flake for KakaoTalk";

  inputs = {
    kakaotalk-exe = {
      url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
      flake = false;
    };
    kakaotalk-icon = {
      url = "https://upload.wikimedia.org/wikipedia/commons/e/e3/KakaoTalk_logo.svg";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, kakaotalk-exe, kakaotalk-icon }: {
    packages.x86_64-linux =
      let
        pkgs = import "${nixpkgs}" {
          system = "x86_64-linux";
        };

      in
      with pkgs; {
        default = self.packages.x86_64-linux.kakaotalk;
        kakaotalk = stdenv.mkDerivation rec {
          pname = "kakaotalk";
          version = "0.1.0";
          src = kakaotalk-exe;
          dontUnpack = true;
          
          nativeBuildInputs = [ 
            makeWrapper 
            wineWowPackages.stable 
            noto-fonts-cjk-sans
            winetricks
          ];
          
          installPhase = ''
            mkdir -p $out/bin $out/share/icons/hicolor/scalable/apps $out/share/kakaotalk
            cp ${kakaotalk-icon} $out/share/icons/hicolor/scalable/apps/kakaotalk.svg
            cp ${src} $out/share/kakaotalk/KakaoTalk_Setup.exe
            
            # Create launcher script
            cat > $out/bin/kakaotalk << EOF
            #!/bin/sh
            export WINEPREFIX="\$HOME/.wine-kakaotalk"
            export WINEARCH=win64

            # Setup wine prefix if it doesn't exist
            if [ ! -d "\$WINEPREFIX" ]; then
              echo "Setting up KakaoTalk Wine environment..."
              ${wineWowPackages.stable}/bin/wineboot --init
              
              # Install Noto CJK fonts
              mkdir -p "\$WINEPREFIX/drive_c/windows/Fonts"
              find ${noto-fonts-cjk-sans}/share/fonts -name "*.otf" -exec cp {} "\$WINEPREFIX/drive_c/windows/Fonts/" \\;
              
              # Install essential Windows components
              ${winetricks}/bin/winetricks -q vcrun2019 corefonts
              
              # Configure DPI scaling for high-DPI displays (200% scaling)
              ${wineWowPackages.stable}/bin/wine reg add "HKCU\\Software\\Wine\\X11 Driver" /v ClientSideGraphics /t REG_SZ /d Y /f
              ${wineWowPackages.stable}/bin/wine reg add "HKCU\\Control Panel\\Desktop" /v LogPixels /t REG_DWORD /d 192 /f
              ${wineWowPackages.stable}/bin/wine reg add "HKCU\\Software\\Wine\\Fonts" /v LogPixels /t REG_DWORD /d 192 /f
              
              # Install KakaoTalk
              echo "Installing KakaoTalk..."
              ${wineWowPackages.stable}/bin/wine "$out/share/kakaotalk/KakaoTalk_Setup.exe" /S
              
              # Wait for installation to complete
              sleep 5
            fi

            # Run KakaoTalk
            ${wineWowPackages.stable}/bin/wine "\$WINEPREFIX/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe" "\$@"
            EOF
            chmod +x $out/bin/kakaotalk
          '';
          meta = with lib; {
            description = "A messaging and video calling app.";
            homepage = "https://www.kakaocorp.com/page/service/service/KakaoTalk";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
          };
        };
      };
    apps.x86_64-linux.kakaotalk = {
      type = "app";
      program = "${self.packages.x86_64-linux.kakaotalk}/bin/kakaotalk";
    };
    apps.x86_64-linux.default = self.apps.x86_64-linux.kakaotalk;
  };
}