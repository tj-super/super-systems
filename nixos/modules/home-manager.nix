{ profile, self, ... }:
{
  home-manager = {
    extraSpecialArgs = {
      inherit self;
    };

    useUserPackages = true;
    users."${profile.username}" = profile.module;
  };
}
