{ pkgs, lib, ... }@args:
let
  inherit (args) user;
  inherit (user) username;
in
{
  users.users.${username} = {
    createHome = lib.mkDefault true;
    home = lib.mkDefault "/Users/${username}";
  };
}
