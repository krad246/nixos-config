# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {};
in
{
  "@trunkio/launcher-1.2.7" = nodeEnv.buildNodePackage {
    name = "_at_trunkio_slash_launcher";
    packageName = "@trunkio/launcher";
    version = "1.2.7";
    src = fetchurl {
      url = "https://registry.npmjs.org/@trunkio/launcher/-/launcher-1.2.7.tgz";
      sha512 = "FDRRc3PYIfrnLrjWdZ5JeB49tkSmoRdrm3940u1o5XK3Zn+EsIUFNC/k6aOHSfUgkIB0LrBwENX8hwfAeW4kzg==";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Trunk CLI tool";
      homepage = "https://trunk.io";
      license = "ISC";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}