{ config, lib, pkgs, modulesPath, ... }:
let
  cryptdata = "/dev/disk/by-label/cryptdata";
  vg0-nix = "/dev/vg0/nix";
  vg0-home = "/dev/vg0/home";
  mount-mkdir = [ "x-mount.mkdir" ];
  vfat-opts = [ "nosuid" "nodev" "noexec" "umask=0077" ] ++ mount-mkdir;
  btrfs-opts = [ "noatime" "compress=zstd:1" "discard=async" ] ++ mount-mkdir;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  boot.initrd.luks.devices = lib.mkAfter {
    root = {
      device = cryptdata;
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
  fileSystems."/" = lib.mkForce {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
    neededForBoot = true;
  };

  # NOTE: Disks are referred to '/by-label/'

  # Persistent store for boot partition (FAT32)
  # no device / block IO files on this FS, and no sudo-ish binaries here.
  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = vfat-opts;
  };

  fileSystems."/nix" = lib.mkDefault {
    device = vg0-nix;
    fsType = "btrfs";
    options = btrfs-opts ++ [ "subvol=@" ];
    neededForBoot = true;
  };

  fileSystems."/nix/store" = lib.mkDefault {
    device = vg0-nix;
    fsType = "btrfs";
    options = btrfs-opts ++ [ "subvol=@store" "x-systend.after=/nix" ];
    neededForBoot = true;
  };

  fileSystems."/nix/persist" = lib.mkForce {
    device = vg0-nix;
    fsType = "btrfs";
    options = btrfs-opts ++ [ "subvol=@persist" "x-systend.after=/nix" ];
    neededForBoot = true;
  };

  # Light compression for tiered speeds (RAM FS, light compress medium size FS, huge high compress store)
  fileSystems."/home" = lib.mkDefault {
    device = vg0-home;
    fsType = "btrfs";
    options = btrfs-opts ++ [ "subvol=@home" ];
    neededForBoot = true;
  };

  fileSystems."/etc/nixos" = lib.mkForce {
    device = "/nix/persist/etc/nixos";
    fsType = "none";
    options = [ "bind" "x-systemd.requires=/nix/persist" ];
  };

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
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.persistence."/nix/persist" = {
    hideMounts = false;
    directories = [
      # journalctl
      "/var/log"

      # nix configuration and state files
      #      {
      #        directory = "/etc/nixos";
      #        user = "nobody";
      #        group = "users";
      #        mode = "0755";
      #      }
      "/var/lib/nixos"

      # managed by systemd; drivers, etc.
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/colord"
      "/var/lib/NetworkManager"
      "/var/lib/systemd"

      # service-specific caches, such as CCache.
      "/var/cache/ccache"
    ];

    files = [ "/etc/machine-id" "/etc/adjtime" ];
  };
}
