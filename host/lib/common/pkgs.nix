{ self, ... }: {
  nixpkgs.overlays = [
    (import "${self}/pkgs/overlay.nix")
  ];
}
