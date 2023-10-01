{ config, pkgs, ... }:
{
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
      # gnu common utils and super common wrappers, etc.
      binutils
      coreutils-full # use the bigger coreutils
      moreutils
      patchutils
      renameutils
      util-linux

      autoconf
      automake
      autogen
      bison
      flex
      m4
      yacc

      libtool
      libtool

      gnumake

      wget
      curl

      file
      killall

      unstable.

      stdenv.cc
      python3Full

      # paging
      less
      lesspipe
      nvimpager

      cachix # binary caching for nix
      plocate # fs indexing

      # wacom
      xf86_input_wacom
      wacomtablet
      libwacom

      lshw

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
