{ config, pkgs, ... }: {

  # EFI loader configs
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    crashDump.enable = true;
    hardwareScan = true;

    # EFI loader is gummiboot
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        memtest86.enable = true;
      };
    };
  };
}
