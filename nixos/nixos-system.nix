{
  self,
  keys,
  inputs,
  system,
  stateVersion,
  profile,
  ...
}:
with inputs;
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      self
      keys
      profile
      ;
  };

  modules = [
    disko.nixosModules.disko
    lanzaboote.nixosModules.lanzaboote
    agenix.nixosModules.default
    home-manager.nixosModules.default

    ./hardware-configuration.nix
    ./modules

    {
      system.stateVersion = stateVersion;
    }
  ];
}
