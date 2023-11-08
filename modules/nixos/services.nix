{ config, lib, pkgs, ... }:
let
in {
  virtualisation = {
    docker.enable = false;
    libvirtd.enable = false;
  };

  services = {
    # Robust shell history in a database
    atuin.enable = true;

    # Sideloading for our env
    flatpak.enable = true;

    # SSD TRIM
    fstrim.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # ZRAM
  zramSwap = {
    enable = true;
    memoryPercent = 40;
    algorithm = "zstd";
  };
}
