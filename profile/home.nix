{
  stateVersion,
  username,
  ...
}:
{
  inherit stateVersion username;

  module = {
    imports = [
      ./modules
    ];

    home = {
      inherit stateVersion username;

      homeDirectory = "/home/${username}";
    };

  };
}
