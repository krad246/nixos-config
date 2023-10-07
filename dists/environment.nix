{ config, pkgs, ... }: {
  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };

    dconf.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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

  environment = {
    enableAllTerminfo = true;

    # LVM autoextension
    etc."/lvm/lvm.conf".text = ''
      allocation {
        thin_pool_autoextend_threshold = 75
        thin_pool_autoextend_percent = 50
      }
    '';

    # pantheon stock apps to eliminate
    pantheon.excludePackages = with pkgs.pantheon; [
      elementary-music
      elementary-tasks
      elementary-feedback
      elementary-calculator
      elementary-code
      elementary-mail
      epiphany
    ];

    systemPackages = with pkgs; [
      coreutils-full moreutils toybox
      patchutils renameutils
      util-linux
 
      asdf gnumake stdenv.cc
      curl git wget
      
      glances lshw neofetch

      neovim
    ];

    shells = with pkgs; [ bash zsh ];
    variables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "$EDITOR";
      VISUAL = "$EDITOR";
    };
  };

  # nix os manuals
  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = true;
    dev.enable = true;
    info.enable = true;
    nixos.enable = true;
  };
}
