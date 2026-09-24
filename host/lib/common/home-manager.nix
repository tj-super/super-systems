{
  profile,
  self,
  inputs,
  system,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        profile
        self
        system
        ;
    };

    users."${profile.username}" = profile.module;

    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
