{ pkgs, lib, ... }: {
  # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Auto upgrade nix package and the daemon service.
  # FIXME: doesn't make sense for nixos
  # services.nix-daemon.enable = true;
  # programs.command-not-found.enable = false;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = lib.const true;
    experimental-features = "nix-command flakes";
  };
}
