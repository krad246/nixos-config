{ config, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;

    history = {
      path = "$HOME/.cache/zsh/history";
      expireDuplicatesFirst = true;
      extended = true;
    };

    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "alias-finder"
        # "common-aliases"
        # "singlechar"

        "sudo"
        "ripgrep"
        "gh"

        "colored-man-pages"
        "colorize"

        "safe-paste"

        "direnv"
        "zsh-interactive-cd"
        "zsh-navigation-tools"
        "zoxide"
      ];
    };

    shellAliases = {
      ls = "${pkgs.lsd}/bin/lsd --color=auto";
      cat = "${pkgs.bat}/bin/bat -p";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
