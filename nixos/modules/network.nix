{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = true;
      DNSSEC = true;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      #"2606:4700:4700::1111#cloudflare-dns.com"
      #"2606:4700:4700::1001#cloudflare-dns.com"
    ];
  };
}
