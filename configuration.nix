# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ config, pkgs, ... }:
let
  impermanence = builtins.fetchTarball
    "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-23.05";

    in {

    imports = [
      ./cachix.nix
      ./platform.nix
      ./dists/boot.nix
      ./dists/environment.nix
      ./dists/locale.nix
      ./dists/services.nix
      "${impermanence}/nixos.nix"
      "${home-manager}/nixos.nix"
    ];

    # enable nix multi-call binaries (nix search etc.)
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    imports = [
      ./nixos/boot.nix
      ./nixos/environment.nix
      ./nixos/hardware-configuration.nix
      ./nixos/locale.nix
      ./nixos/services.nix
      "${home-manager}/nixos"
    ];

    # enable nix multi-call binaries (nix search etc.)
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # External, non-FOSS imports
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    system.copySystemConfiguration = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

    # Keep stuff up to date automatically
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;

    # See home.nix for userspace management.
    users.mutableUsers = false;
    users.users.root.initialPassword = "nix";

    environment.persistence."/nix/persist" = {
      hideMounts = true;

      directories = [
        "/boot"
        "/nix"
        "/home"
        "/etc/nixos"
        "/etc"

        "/etc/NetworkManager/system-connections"

        "/var/tmp"
        "/tmp"

        "/var/log"

        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }

        "/var/spool"
        "/var/db"
      ];

      files = [
        #     "/etc/machine-id"
        #     {
        #       file = "/etc/nix/id_rsa";
        #       parentDirectory = { mode = "u=rwx,g=o="; };
        #     }
      ];

      users.keerthi = {
        directories = [ "Downloads" "Music" "Pictures" "Documents" "Videos" ];
      };
    };

    # Add me!!!
    users.users.keerthi = {
      isNormalUser = true;
      description = "Keerthi R.";
      initialPassword = "nix";
      extraGroups = [ "wheel" "sudo" "networkmanager" "plugdev" "dialout" ];
    };
  }
