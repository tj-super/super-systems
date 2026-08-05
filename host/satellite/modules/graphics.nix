{ profile, lib, ... }:
{
  # boot.kernelParams = [ "i915.enable_psr=0" ]; # todo: didn't fix

  home-manager.users."${profile.username}".wayland.windowManager.hyprland.settings = {
    misc.vrr = 0;
    monitor = lib.mkForce [
      "eDP-1, 1920x1080@60, auto-right, 1"
    ];
  };
}
