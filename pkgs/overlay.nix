final: prev: {
  imapsync-oauth2_imap = prev.callPackage ./imapsync-oauth2_imap.nix { };
  imapsync-oauth2_imap_refresh = prev.callPackage ./imapsync-oauth2_imap_refresh.nix { };
}
