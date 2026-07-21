let
  keys = import ../keys/keys.nix;

  user = keys.ssh.user.pub;
  system = keys.ssh.host.pub;

  publicKeys = [
    user
    system
  ];
in
{
  "ages/ssh-host-key.age" = { inherit publicKeys; };
  "ages/ssh-user-key.age" = { inherit publicKeys; };
  "ages/user-password.age" = { inherit publicKeys; };
}
