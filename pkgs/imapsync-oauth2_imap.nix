{
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  perl,
}:

let
  perlEnv = perl.withPackages (
    perlPackages: with perlPackages; [
      HTTPDaemonSSL
      JSON
      LWP
      LWPProtocolHttps
      MailIMAPClient
      EmailAddress
      NetDNS
    ]
  );

  script = ./imapsync-oauth2_imap.sh;
in
stdenvNoCC.mkDerivation rec {
  pname = "imapsync-oauth2_imap";
  version = "2.314";

  src = fetchFromGitHub {
    owner = "imapsync";
    repo = "imapsync";
    rev = "imapsync-${version}";
    hash = "sha256-uNpKtF26ey0OGgAmsxzyaWQzZC+vcs6cLodDqAF6VIw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/oauth2_imap
    cp -r oauth2/oauth2_imap/* $out/share/oauth2_imap/

    # Copy the wrapper template to $out/bin
    cp ${script} $out/bin/imapsync-oauth2_imap
    chmod +x $out/bin/imapsync-oauth2_imap

    # Substitute the placeholders using the actual $out directory of this derivation
    substituteInPlace $out/bin/imapsync-oauth2_imap \
      --replace-fail "@perlBin@" "${perlEnv}/bin/perl" \
      --replace-fail "@oauth2Dir@" "$out/share/oauth2_imap"

    runHook postInstall
  '';

  meta = {
    description = "OAuth2 authentication helper for IMAP via imapsync";
    homepage = "https://github.com/imapsync/imapsync";
    license = "NO LIMIT PUBLIC LICENSE";
    mainProgram = "imapsync-oauth2_imap";
  };
}
