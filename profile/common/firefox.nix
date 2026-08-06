{
  programs.firefox =
    let
      ublockOrigin = "uBlock0@raymondhill.net";
      privacyBadger = "jid1-MnnxcxisBPnSXQ@jetpack";
    in
    {
      enable = true;

      policies = {
        ExtensionSettings = {
          "${ublockOrigin}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ublockOrigin}/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "${privacyBadger}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${privacyBadger}/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
      };

      profiles.super = {
        extensions = {
          force = true;

          settings."${ublockOrigin}".settings = {
            selectedFilterLists = [
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "ublock-quick-fixes"
            ];
          };

          settings."${privacyBadger}".settings = { };
        };
      };
    };
}
