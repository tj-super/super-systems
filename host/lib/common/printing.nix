{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-filters ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
