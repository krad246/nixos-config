

{ config, pkgs, ... }: {
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # powerline fonts and the like for fancy oh-my-zsh goodness
  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [ fira-code fira-code-symbols nerdfonts ];
  };
}
