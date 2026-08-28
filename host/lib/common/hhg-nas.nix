{ config, pkgs, ... }:

{
  age.secrets.hhg_nas = {
    file = ../../secrets/hhg_nas.age;
    mode = "0400";
  };

  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/nas" = {
    device = "//192.168.0.151/HopeHouse";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [
        "${automount_opts}"
        "credentials=${config.age.secrets.hhg_nas.path}"
        "uid=1000"
        "gid=100"
      ];
  };
}
