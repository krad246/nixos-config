{ ... }: {
  imports = [ ./git.nix ];
  programs.gh = { enable = true; };
}
