{ config
, pkgs
, lib
, ...
}: {
  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };

  # A cache needs to be rebuild for the themes to show up
  # home.activation.bat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.bat}/bin/bat cache --build 1>/dev/null
  # '';
}
