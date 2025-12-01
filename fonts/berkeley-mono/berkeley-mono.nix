{ stdenv, lib, unzip }:
stdenv.mkDerivation {
  pname = "berkeley-mono";
  version = "2025-07-02";
  src = ./berkeley-mono.zip;
  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";
  installPhase = ''
    install -Dm644 *.otf -t $out/share/fonts/opentype
  '';
  meta.description = "Berkeley Mono type family";
}
