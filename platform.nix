{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-label/cryptdata";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Impermanence tmpfs root (lives in RAM)
  # TODO: Try tmpfs on ZRAM???
  fileSystems."/" = pkgs.lib.mkForce {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" "size=16G" ];
    neededForBoot = true;
  };

  # NOTE: Disks are referred to '/by-label/'

  # Persistent store for boot partition (FAT32)
  # no device / block IO files on this FS, and no sudo-ish binaries here.
  fileSystems."/nix/persist/boot" = pkgs.lib.mkForce {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    neededForBoot = true;
    options = [ "defaults" "noatime" "umask=0077" "nosuid" "nodev" ];
  };

  fileSystems."/boot" = pkgs.lib.mkForce {
    device = "/nix/persist/boot";
    fsType = "none";
    options = [ "bind" ];
  };

  # Slow commit rate since Nix transactions are atomic
  # Rest is pretty standard fare for 'best BTRFS options reddit'
  fileSystems."/nix" = pkgs.lib.mkForce {
    device = "/dev/vg0/nix";
    fsType = "btrfs";
    options = [
      "defaults"
      "commit=120"
      "compress=zstd:1"
      "discard=async"
      "noatime"
      "autodefrag"
      "usebackuproot"
    ];
    neededForBoot = true;
  };

  # OS config wil actually go in the 'distributions' directory
  # this should be full of symlinks so should be pretty small
  # faster commit rate for quicker syncs here
  # Light compression for tiered speeds (RAM FS, light compress medium size FS, huge high compress store)
  fileSystems."/nix/persist" = pkgs.lib.mkForce {
    device = "/dev/vg0/dists";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "defaults"
      "commit=60"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
    neededForBoot = true;
  };

  # persistent config might as well live under the parent mount of /nix
  fileSystems."/nix/config" = pkgs.lib.mkForce {
    device = "/nix/persist/nix/config";
    fsType = "none";
    options = [ "bind" ];
  };

  # This is actually just /etc/nixos
  fileSystems."/etc/nixos" = pkgs.lib.mkForce {
    device = "/nix/config";
    fsType = "none";
    options = [ "bind" ];
  };

  # OS config wil actually go in the 'distributions' directory
  # this should be full of symlinks so should be pretty small
  # faster commit rate for quicker syncs here
  # Light compression for tiered speeds (RAM FS, light compress medium size FS, huge high compress store)
  fileSystems."/nix/persist/home" = pkgs.lib.mkForce {
    device = "/dev/vg0/home";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "defaults"
      "commit=60"
      "compress=zstd:1"
      "discard=async"
      "noatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/home" = pkgs.lib.mkForce {
    device = "/nix/persist/home";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  # ZRAM
  zramSwap = {
    enable = true;
    memoryPercent = 35;
    memoryMax = 21474836480;
    algorithm = "zstd";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

}
