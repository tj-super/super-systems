{ pkgs, ... }: {
  programs.lutris = {
    enable = true;
  };

  home.packages = [
    pkgs.gamescope
  ];
}
