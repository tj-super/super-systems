{ lib, profile, ... }: {
  virtualisation.vmVariant = {
    system.activationScripts.install-host-keys = {
      text = ''
        SRC="/tmp/shared/ssh"
        if [ -f "$SRC/ssh_host_ed25519_key" ]; then
          install -D -m 600 "$SRC/ssh_host_ed25519_key"     /etc/ssh/ssh_host_ed25519_key
          install -D -m 644 "$SRC/ssh_host_ed25519_key.pub" /etc/ssh/ssh_host_ed25519_key.pub
          echo "SSH host keys installed from host."
        else
          exit "ERROR: SSH host keys not found in $SRC" >&2
        fi
      '';
    };

    system.activationScripts.agenixInstall.deps = [ "install-host-keys" ];

    users.users.root = {
      hashedPassword = lib.mkForce null;
      password = lib.mkForce "Password1!";
    };

    home-manager.users.${profile.username}.wayland.windowManager.hyprland.settings = {
      monitor = [
        "Virtual-1, 1920x1080, 0x0, 1"
      ];
    };

    virtualisation = {
      graphics = true;
      cores = 4;
      memorySize = 8192;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on"
      ];
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "pixman";
    };
  };
}
