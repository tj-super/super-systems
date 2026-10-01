{
  networking.hostName = "satellite";
  time.timeZone = "America/Chicago";
  system.stateVersion = "26.05";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192;
    }
  ];
}
