{ pkgs, lib, ... }@args:
let
  # FIXME
  inherit (args) hostname user;
  inherit (user) username;
  # hostname = "nixos";
  # username = "krad246";
  # user = { uid = 1000; gid = 100; };
in
{
  users.users.${username} = {
    description = lib.mkDefault "${username}";
    inherit (user) uid gid;

    # isNormalUser = true;
    # passwordFile = "/secrets/passwd";
    # extraGroups = [ "wheel" ] ++ optionalGroups [ "NetworkManager" ];
  };

  # Impermanence plus the fact that you don't really change users themselves makes this
  # an easy option to justify.
  # FIXME
  # users.mutableUsers = false;

  # FIXME
  # users.knownUsers = [ "${username}" ];
  nix.settings.trusted-users = [ "${username}" ];
  networking.hostName = hostname;
}
