{
  profile,
  self,
  inputs,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit self inputs profile;
    };

    users."${profile.username}" = profile.module;

    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
