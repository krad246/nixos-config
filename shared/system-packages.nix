{ pkgs, lib, ... }: {
  environment = {
    # enableAllTerminfo = true;
    systemPackages = with pkgs; [
      # uutils-coreutils-noprefix
      rtx

      aria2 # A lightweight parallel command-line download utility
      ripgrep # recursively searches directories for a regex pattern
      safe-rm

      neofetch
      bottom
    ] ++ lib.optionals stdenv.isDarwin [ m-cli ];
  };
  # nix os manuals
  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = true;
    info.enable = true;
  };
  # // pkgs.lib.optionals pkgs.stdenv.isLinux {
  #   # dev.enable = true;
  #   # nixos.enable = true;
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  # i18n.defaultLocale = lib.optionals pkgs.stdenv.isLinux "en_US.UTF-8";

  # powerline fonts and the like for fancy oh-my-zsh goodness
  fonts = {
    # fontconfig.enable = lib.optionals pkgs.stdenv.isLinux true;
    fonts = with pkgs; [ nerdfonts font-awesome ];
  };

  programs.zsh.enable = true;


  programs = {
    bash = {
      # enableLsColors = true;
      enableCompletion = true;
    };

    # direnv = {
    #   enable = true;
    #   nix-direnv = {
    #     enable = true;
    #   };
    # };

    # git = {
    #   enable = true;
    #   lfs.enable = true;
    #   package = pkgs.gitFull;
    # };

    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    # };

    # pantheon-tweaks.enable = true;
  };
}
