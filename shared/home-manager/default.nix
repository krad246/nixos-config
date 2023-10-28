{ lib, ... }@args:
let
  inherit (args) stateVersion;
in
{
  home.stateVersion = "${stateVersion}";

  # Applies inside of the home-manager config
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = lib.const true;
    experimental-features = "nix-command flakes";
  };

  # Applies for imperative commands
  # xdg.configFile."nixpkgs/config.nix".text = ''
  #   {
  #     allowUnfree = true;
  #     experimental-features = "nix-command flakes";
  #   }
  # '';

  imports = [ ./home.nix ];
}
