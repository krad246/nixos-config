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
    trunk=${builtins.toString ./.trunk}
    if [[ ! -e $trunk ]]; then
      env --chdir=$TOP trunk init -yv
    elif [[ -d $trunk ]]; then
      true
    else
      rm -i $trunk
      env --chdir=$TOP trunk init -yv
    fi
  '';
}
