{
  stateVersion,
  username,
  ...
}:
{
  inherit stateVersion username;

  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo0rqolIwrG9+2xM6nQSDmPkEAprLEstESby+KtwoDa super@super-systems";
  privateKeyFile = ./secrets/id_ed25519.age;
  passwordFile = ./secrets/user-password.age;

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
