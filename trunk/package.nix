{ pkgs ? import <nixpkgs> { } }:
pkgs.callPackage ./trunk-static.nix { }

# TODO: Consider making the manifest also its own small meta-package.
