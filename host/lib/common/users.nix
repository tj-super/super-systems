{
  config,
  profile,
  lib,
  ...
}:
{
  age.secrets.user-password.file = profile.passwordFile;

  users = {
    mutableUsers = false;

    users.root.hashedPassword = "!";

    users."${profile.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-password.path;
      extraGroups = [
        "wheel"
      ];
    };
  };

  virtualisation.vmVariant = {
    users.users.root = {
      hashedPassword = lib.mkForce null;
      password = lib.mkForce "root";
    };
  };
}
