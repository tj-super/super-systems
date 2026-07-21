{
  stateVersion,
  username,
  inputs,
}:
with inputs;
{
  inherit stateVersion username;

  module = { pkgs, ... }: {
    imports = [
      ./modules
    ];

    home = {
      inherit stateVersion username;

      homeDirectory = "/home/${username}";

      packages = with pkgs; [
        vscodium
        direnv
      ];
    };

  };
}
