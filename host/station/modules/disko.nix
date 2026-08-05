{
  disko.devices = {
    disk = {

      ssd1 = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANM0R517283D";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            nixos = {
              size = "50G";
              content = {
                type = "luks";
                name = "nixos1";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "nixos"
                  ];
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                  ];
                };
              };
            };
            home = {
              size = "200G";
              content = {
                type = "luks";
                name = "home1";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "home"
                  ];
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                  ];
                };
              };
            };
            extra = {
              size = "100%";
              content = {
                type = "luks";
                name = "extra1";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "extra"
                  ];
                  mountpoint = "/extra";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                  ];
                };
              };
            };
          };
        };
      };

      ssd2 = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANM0R519175L";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
            };
            nixos = {
              size = "50G";
              content = {
                type = "luks";
                name = "nixos2";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "nixos"
                    "-m"
                    "raid1"
                    "-d"
                    "raid0"
                    "/dev/mapper/nixos1"
                  ];
                };
              };
            };
            home = {
              size = "200G";
              content = {
                type = "luks";
                name = "home2";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "home"
                    "-m"
                    "raid1"
                    "-d"
                    "raid1"
                    "/dev/mapper/home1"
                  ];
                };
              };
            };
            extra = {
              size = "100%";
              content = {
                type = "luks";
                name = "extra2";
                passwordFile = "/tmp/luks.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "extra"
                    "-m"
                    "raid1"
                    "-d"
                    "raid0"
                    "/dev/mapper/extra1"
                 ];
                };
              };
            };
          };
        };
      };

    };
  };
}
