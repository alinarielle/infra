{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    priority = 5;
    memoryPercent = 50;
  };
}
