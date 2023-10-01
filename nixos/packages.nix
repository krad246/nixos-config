{ config, pkgs, ... }: {
  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };

    direnv = {
      enable = true;
      nix-direnv = {
	enable = true;
      };
    };

    git = {
      enable = true;
      lfs.enable = true;
      package = pkgs.gitFull;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    pantheon-tweaks.enable = true;
  };

  environment.systemPackages = with pkgs; [
    busybox
    toybox
    asdf
    gnumake
    stdenv.cc
    glances
    lshw
    neofetch
  ];
}
