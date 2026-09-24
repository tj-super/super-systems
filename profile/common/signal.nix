{ system, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
{
  home.packages = with pkgs-unstable; [
    signal-desktop
  ];
}
