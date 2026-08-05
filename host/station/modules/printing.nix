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
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_MF660C";
        location = "Home Office";
        deviceUri = "ipp://192.168.2.50/ipp/print"; 
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
    ensureDefaultPrinter = "Canon_MF660C";
  };
}
