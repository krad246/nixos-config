{


  description = "My NixOS configuration, using home-manager";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # macOS compatibility layer
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # userspace config management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # basically macro libraries and stuff to unify the old and new nix interfaces
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    nix-helpers = {
      url = "github:Warbo/nix-helpers";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-helpers
    , ...
    } @ inputs:

    let
      inherit (inputs) flake-utils;
    in

    # this is basically a function-like macro, where the following
      # body is generated and merged into the outputs defined.
      # i.e. we're going to get packages.<eachSystem> = ...;
      # and so on
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        helpers = pkgs.callPackage nix-helpers { nixpkgs-lib = lib; nixpkgs = pkgs; };

        # repo QA / CI tools
        formatter = pkgs.nixpkgs-fmt;
        linter = pkgs.statix;
        analyzer = pkgs.deadnix;

        # 'macro' encapsulating the samey act of calling a tool
        makeCheck = tool: script:
          pkgs.runCommand "${tool.pname}"
            {
              src = ./.;
              buildInputs = [ tool ];
            }
            ''${script "${tool.pname}"} && mkdir -p $out'';
      in
      rec {
        # just re-exporting interfaces
        packages = { inherit formatter linter analyzer; };
        checks = rec {
          fmt = makeCheck packages.formatter (fmt: ''${fmt} $src'');
          lint = makeCheck packages.linter (linter: ''${linter} check $src'');
          analyze = makeCheck packages.analyzer (analyzer: ''${analyzer} $src'');
        };

        devShells.default = pkgs.mkShell { packages = [ formatter linter analyzer ]; };
        inherit formatter;
      }) //

    flake-utils.lib.eachDefaultSystem (system:
    let
      create = import ./create-system.nix { inherit (inputs) nixpkgs nix-darwin home-manager; };
    in
    rec
    {
      # basically library-like structures
      nixosModules = {
        darwinConfigurations = rec {
          default = nixos-darwin;
          nixos-darwin = create.createSystem
            # profile modules
            {
              stateVersion = "23.05";
              modules = [ ./shared ./modules/darwin ./modules/shims/system ];
              home-manager = {
                enable = true;
                modules = [ ./shared/home-manager ./modules/shims/home-manager ];
              };
            }

            # extra stuff
            {
              inherit system;
              user = {
                username = "krad246";
                uid = 501;
                gid = 20;
              };

              hostname = "nixos-darwin";
            };
        };
      };

      legacyPackages = {
        inherit (nixosModules) darwinConfigurations;
      };

      # we call the configuration and force its package eval into a derivation by fetching the system attr
      # that gives us the checks and all the interfaces we need
      packages = rec {
        inherit (legacyPackages.darwinConfigurations.default) system;
        default = system;
      };

    });

}
