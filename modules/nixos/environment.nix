{ config, pkgs, ... }:
{
  # Impermanence plus the fact that you don't really change users themselves makes this
  # an easy option to justify.
  users.mutableUsers = false;
}
