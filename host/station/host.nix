{
  self,
  system,
  inputs,
  profile,
}:
{
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9MF0ces+d0AlXjcoIA3WBwqrgD55C7AxRsyZpW5cVU root@super-station";
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
      inputs.disko.nixosModules.default

      ../lib/modules

      ./hardware-configuration.nix
      ./configuration.nix
      ./modules
    ];
  };
}
