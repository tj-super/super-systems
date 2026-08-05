{ profile, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };

  virtualisation.vmVariant = {
    home-manager.users.${profile.username}.wayland.windowManager.hyprland.settings = {
      monitor = [
        "Virtual-1, 1920x1080, 0x0, 1"
      ];
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "pixman";
    };
  };
}
