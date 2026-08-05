{
  profile,
  config,
  ...
}:
{
  age.secrets.id_ed25519 = {
    file = profile.privateKeyFile;
    mode = "600";
    owner = profile.username;
    group = "users";
  };

  systemd.tmpfiles.rules = [
    "d /home/${profile.username}/.ssh 0700 ${profile.username} users - -"
    "L+ /home/${profile.username}/.ssh/id_ed25519 - - - - ${config.age.secrets.id_ed25519.path}"
  ];

  home-manager.users."${profile.username}" = {
    home.file.".ssh/id_ed25519.pub".text = profile.publicKey;
  };

  services.openssh = {
    enable = true;

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    profile.publicKey
  ];

  users.users."${profile.username}".openssh.authorizedKeys.keys = [
    profile.publicKey
  ];
}
