{
  ssh = {
    user = {
      pub = builtins.readFile ./ssh/user.pub;
      keyFile = ./ssh/user.key;
    };
    host = {
      pub = builtins.readFile ./ssh/host.pub;
      keyFile = ./ssh/host.key;
    };
  };
}
