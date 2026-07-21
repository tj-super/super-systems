{
  keys,
  config,
  profile,
  ...
}:
{
  users = {
    mutableUsers = false;

    users.root.hashedPassword = "!";

    users."${profile.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-password.path;
      openssh.authorizedKeys.keys = [
        keys.ssh.user.pub
      ];
      extraGroups = [
        "wheel"
      ];
    };
  };
}
