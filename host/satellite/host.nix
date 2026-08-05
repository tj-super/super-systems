{
  self,
  system,
  inputs,
  profile,
}:

{
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhXYxoD0qOmpPabvfVykMG+GYip90qqUeGO+g+qBW4J root@super-satellite";
  privateKeyFile = ./secrets/ssh_host_ed25519_key.age;

  nixosConfiguration = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit
        self
        inputs
        profile
        ;
    };

    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.default

      ../lib/modules

      ./hardware-configuration.nix
      ./configuration.nix
      ./modules
    ];
  };
}
