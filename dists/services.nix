{ config, pkgs, ... }:
let
  nixpkgs-unstable = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
in {
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = false;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    steam-hardware.enable = true;
  };

  # Sound administered via Pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  networking.hostName = "nix-eos";
  networking.networkmanager.enable = true;
  services = {
    # Robust shell history in a database
    atuin.enable = true;

    # Sideloading for our env
    flatpak.enable = true;

    # All the bells and whistles for our filesystem usage
    lvm = {
      enable = true;
      dmeventd.enable = true;
      boot.thin.enable = true;
   };

    # Bells and whistles from Pantheon
    pantheon = {
      apps.enable = true;
      contractor.enable = true;
    };

    # SSD TRIM
    fstrim.enable = true;
    system76-scheduler.enable = true;

    # Enable X11 windowing.
    # Select the Pantheon desktop environment (elementary OS)
    # Add extra indicators and panel plugins.
    # Enable high-resolution booting.
    # Enable wacom tablets.
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      desktopManager.pantheon = {
          enable = true;
          extraWingpanelIndicators = with pkgs.pantheon; [
            wingpanel-indicator-network
            wingpanel-indicator-notifications
            wingpanel-indicator-bluetooth
            wingpanel-indicator-session
            wingpanel-indicator-nightlight
            wingpanel-indicator-keyboard
            wingpanel-indicator-a11y
            wingpanel-indicator-datetime
            wingpanel-indicator-power
          ];

          extraSwitchboardPlugs = with pkgs.pantheon; [
            switchboard-plug-keyboard
            switchboard-plug-network
            switchboard-plug-onlineaccounts
            switchboard-plug-mouse-touchpad
            switchboard-plug-datetime
            switchboard-plug-bluetooth
            switchboard-plug-sound
            switchboard-plug-applications
            switchboard-plug-power
            switchboard-plug-a11y
            switchboard-plug-pantheon-shell
            switchboard-plug-printers
            switchboard-plug-security-privacy
            switchboard-plug-notifications
            switchboard-plug-about
            switchboard-plug-display
            switchboard-plug-wacom
          ];
        };

      videoDrivers = [ "modesetting" ];
      wacom.enable = true;
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ZRAM
  zramSwap = {
    enable = true;
    memoryPercent = 35;
    memoryMax = 21474836480;
    algorithm = "zstd";
  };
}
