{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./trunk.nix {}
