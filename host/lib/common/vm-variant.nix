{
  virtualisation.vmVariant = {
    virtualisation = {
      graphics = true;
      #graphics = false;

      cores = 4;
      memorySize = 8192;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on"
      ];
    };
  };
}
