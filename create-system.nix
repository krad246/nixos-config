{ nixpkgs
, nix-darwin
, home-manager
, ...
}:
let
  inherit (nixpkgs) lib;
in
rec {
  # Generate a NixOS/nix-darwin configuration based on a profile, with optional home-manager
  # support. A common configuration (refered to as a "profile") is used to share code between
  # flakes. This is used to avoid code repetition for flakes that configure multiple machines.

  # Example:
  #
  # lib.createSystem
  # {
  #   # The profile, usually defined elsewhere
  #   modules = [ ./modules/graphical.nix ];
  #   home-manager = {
  #     enable = true;
  #     modules = [ ./home-manager/modules/zsh.nix ];
  #   };
  # }
  createSystem = profile: { system
                          , hostname
                          , user
                          , ...
                          } @ args:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      systemModules = args.modules or profile.modules or [ ];
      hmProfile = rec {
        enable = profile.home-manager.enable or false;
        sharedModules = profile.home-manager.modules or [ ];
        modules = sharedModules;
        imports = modules;
      };

      makeSystem =
        if pkgs.stdenv.isDarwin
        then nix-darwin.lib.darwinSystem
        else nixpkgs.lib.nixosSystem;

      makeHome =
        if pkgs.stdenv.isDarwin
        then home-manager.darwinModules.home-manager
        else home-manager.nixosModules.home-manager;

      inherit (user) username;
    in
    makeSystem
      rec {
        inherit system;

        # forward the hostname and user conf
        specialArgs = { inherit hostname user; inherit (profile) stateVersion; };
        modules = systemModules ++ (lib.optionals hmProfile.enable [
          makeHome
          {
            home-manager = {
              extraSpecialArgs = {
                inherit hostname;
                inherit (user) username;
                inherit (profile) stateVersion;
              };

              inherit (hmProfile) sharedModules;
              users.${username} = { inherit (hmProfile) imports; };

              verbose = true;
              backupFileExtension = "~";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ]);
      };
}
