{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
      };
      background = [
        {
          monitor = "";
          path = "screenshot"; # Blurs your active screen workspace
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          position = "0, -80";
          monitor_alignment = "center";
          fade_on_empty = false;
        }
      ];
    };
  };
}

/*
  empty screen
  {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
        };

        background = [
          {
            monitor = "";
            color = "rgb(0, 0, 0)";
          }
        ];

        input-field = [ ];
        label = [ ];
      };
    };
  }
*/
