{
  lib,
  stdenvNoCC,
  makeWrapper,
  curl,
  jq,
}:

let
  script = ./imapsync-oauth2_imap_refresh.sh;
in
stdenvNoCC.mkDerivation rec {
  pname = "imapsync-oauth2_imap_refresh";
  version = "1.0.0";
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${script} $out/bin/imapsync-oauth2_imap_refresh
    chmod +x $out/bin/imapsync-oauth2_imap_refresh

    wrapProgram $out/bin/imapsync-oauth2_imap_refresh \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "OAuth2 access token refresher script for imapsync with Gmail and Office 365 support";
    license = licenses.mit;
    mainProgram = "imapsync-oauth2_imap_refresh";
    platforms = platforms.all;
  };
}
