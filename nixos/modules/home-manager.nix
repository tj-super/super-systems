{
  profile,
  self,
  inputs,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit self inputs;
    };

    useUserPackages = true;
    users."${profile.username}" = profile.module;
  };
}
