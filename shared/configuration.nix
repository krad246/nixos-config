{ config, pkgs, stateVersion ? "23.05", ... }:
{
  system = {
    inherit stateVersion;
    copySystemConfiguration = true;
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  nix = {
    optimise.automatic = true;
    gc = { 
      automatic = true; 
      dates = "weekly"; 
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      sandbox = true;
    };
  };
  
  # rest of the config is behind
  imports = [ ../modules ];
}
