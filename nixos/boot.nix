{ config, pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    crashDump.enable = false;
    hardwareScan = false;

    # EFI loader is gummiboot
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
      };
    };
  };
}
