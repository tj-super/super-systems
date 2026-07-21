{ config, self, ... }:
{
  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile "${self}/keys/ssh/user.pub"}";

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "TJ Super";
        email = "tj.super@proton.me";
      };

      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
  };
}
