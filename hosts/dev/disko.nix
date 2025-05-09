{
  disko.devices.disk.nixos = {
    content = {
      partitions = {
        boot = {
          size = "1M";
          type = "EF02";
        };
        ESP = {
          content = {
            format = "vfat";
            mountpoint = "/boot";
            type = "filesystem";
          };
          size = "512M";
          type = "EF00";
        };
        root = {
          content = {
            format = "ext4";
            mountpoint = "/";
            type = "filesystem";
          };
          size = "100%";
        };
      };
      type = "gpt";
    };
    device = "/dev/nvme0n1";
    type = "disk";
  };
}
