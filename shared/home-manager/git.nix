{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Keerthi Radhakrishnan";
    userEmail = "krad246@gmail.com";

    lfs.enable = true;
    package = pkgs.gitFull;



    aliases = { };

    extraConfig = { pull.rebase = true; };

    # Prettier pager, adds syntax highlighting and line numbers
    delta = {
      enable = true;

      options = {
        navigate = true;
        line-numbers = true;
        conflictstyle = "diff3";
      };
    };
  };
}
