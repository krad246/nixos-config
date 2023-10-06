let
  pkgs = import <nixpkgs> {};
  trunk = pkgs.callPackage ./trunk {};
in pkgs.mkShell {
  packages = with pkgs; [
    git
    direnv
    nix-direnv
  ];
  buildInputs = [ trunk."@trunkio/launcher-1.2.7" ];
  shellHook = ''
    trunkdir=${builtins.toString ./.}
    trunk=$trunkdir/.trunk
    if [[ ! -d $trunk ]]; then
      if [[ -e $trunk ]]; then
        rm -i $trunk
      fi
      env --chdir=$trunkdir trunk init -yv
    fi
  '';
}
