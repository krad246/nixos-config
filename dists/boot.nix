{ config, pkgs, ... }: {

  # EFI loader configs
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Some additional features that *unfortunately* need a recompile.
    crashDump.enable = false;
    hardwareScan = false;

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
