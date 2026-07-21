{ pkgs, ... }: {

  home.packages = with pkgs; [
    kitty
    kdePackages.dolphin
    waybar
    wofi
    grimblast
    hyprpaper
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "hyprlang";
    settings = import ./settings.nix;
  };
}
