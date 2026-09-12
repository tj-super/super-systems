{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    imapsync
    imapsync-oauth2_imap
    imapsync-oauth2_imap_refresh
  ];
}
