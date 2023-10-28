{ config, pkgs, ... }:
{
  environment.persistence."/nix/persist" = {
    hideMounts = false;
    directories = [
      "/etc/NetworkManager/system-connections"

      "/var/log"
      "/var/lib/bluetooth"
      # "/var/lib/nixos"
      "/var/lib/systemd"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];

    files = [ "/etc/machine-id" "/etc/adjtime" ];
  };
}
