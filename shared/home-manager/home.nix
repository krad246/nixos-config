{ config, pkgs, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim.git";
    ref = "nixos-23.05";
  });

  unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
in
{

  # External, non-FOSS imports
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  imports = [ nixvim.homeManagerModules.nixvim ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "keerthi";
  home.homeDirectory = "/home/keerthi";
  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    bitwarden

    firefox

    discord
    gnome.geary
    signal-desktop
    zoom-us

    spotify
    steam

    helix
    obsidian
    gh

    pavucontrol
    picocom

    gdbgui
    gdb

    avrdude
    pico-sdk
    openfpgaloader
    mbedtls
    mbed-cli
  ];

  manual.manpages.enable = false;
  home.sessionVariables = { };
  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
    };

    vscode = {
      enable = true;
      package = unstable.vscode.fhs;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "asdf"
          "colored-man-pages"
          "colorize"
          "command-not-found"
          "common-aliases"
          "cp"
          "direnv"
          "dircycle"
          "extract"
          "fastfile"
          "gh"
          "git-auto-fetch"
          "git-escape-magic"
          "git-extras"
          "gitfast"
          "gitignore"
          "git-lfs"
          "gnu-utils"
          "history"
          "isodate"
          "last-working-dir"
          "magic-enter"
          "man"
          "pip"
          "pre-commit"
          "repo"
          "ripgrep"
          "rsync"
          "safe-paste"
          "shrink-path"
          "singlechar"
          "sudo"
          "systemd"
          "themes"
          "universalarchive"
          "urltools"
          "zoxide"
          "zsh-interactive-cd"
          "zsh-navigation-tools"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
        ];
      };
    };

    git = {
      enable = true;
      lfs.enable = true;
      package = pkgs.gitFull;
    };

    home-manager.enable = true;
  };
}
