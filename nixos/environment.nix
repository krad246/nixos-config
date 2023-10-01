{ config, pkgs, ... }: 
  let 
  groupExists = (group: builtins.hasAttr group config.users.groups);
  optionalGroups = (groups: builtins.filter groupExists groups);
  in
{
  environment = {
    enableAllTerminfo = true;
    shells = with pkgs; [ bash zsh ];
  };

  # nix os manuals
  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = true;
    dev.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # powerline fonts and the like for fancy oh-my-zsh goodness
  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [ nerdfonts font-awesome ];
  };

  # Impermanence plus the fact that you don't really change users themselves makes this
  # an easy option to justify.
  users.mutableUsers = false;

  users.users.krad246 = {
    isNormalUser = true;
    passwordFile = "/secrets/passwd";
    extraGroups = [ "wheel" ] ++ optionalGroups [ "NetworkManager"];
  };
}
