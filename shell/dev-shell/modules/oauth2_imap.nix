{
  pkgs,
  ...
}:
let

  oauth2_imap =
    let
      imapsync-src = pkgs.fetchFromGitHub {
        owner = "imapsync";
        repo = "imapsync";
        rev = "master";
        hash = "sha256-uNpKtF26ey0OGgAmsxzyaWQzZC+vcs6cLodDqAF6VIw=";
      };

      scriptDir = "${imapsync-src}/oauth2/oauth2_imap";

      perl = pkgs.perl.withPackages (
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
    in
    pkgs.writeShellApplication {
      name = "oauth2_imap";
      runtimeInputs = [
        perl
      ];
      text = ''
        TOKEN_FILE="$PWD/oauth2_imap_token.txt"
        cd "${scriptDir}" && \
          exec perl "./oauth2_imap" --token_file "$TOKEN_FILE" "$@"
      '';
    };
in
{
  buildInputs = [
    oauth2_imap
  ];
}
