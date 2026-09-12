{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    imapsync
    imapsync-oauth2_imap
  ];
}
