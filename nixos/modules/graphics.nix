{ lib, ... }: {
  hardware = {
    graphics.enable = true;
    nvidia.open = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];
}
