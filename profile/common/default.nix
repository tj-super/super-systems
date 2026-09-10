{
  imports = [
    ./direnv.nix
    ./firefox.nix
    ./git.nix
    ./lutris.nix
    ./shell.nix
    ./signal.nix
    ./vscodium.nix
  ];

  programs.thunderbird.enable = true;
}
