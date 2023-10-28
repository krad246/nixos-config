{ _, ... }: {

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    defaults = {
      ActivityMonitor = {
        ShowCategory = 101;
        IconType = 0;
      };

      NSGlobalDomain = {
        AppleShowAllFiles = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;

        # Enable full keyboard access for all controls
        # (e.g. enable Tab in modal dialogs)
        AppleKeyboardUIMode = 3;

        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Automatic";
        AppleScrollerPagingBehavior = true;

        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = true;
        NSAutomaticQuoteSubstitutionEnabled = true;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSAutomaticWindowAnimationsEnabled = true;
        NSDisableAutomaticTermination = false;
        NSDocumentSaveNewDocumentsToCloud = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSTableViewDefaultSizeMode = 2;

        # Set a blazingly fast keyboard repeat rate
        InitialKeyRepeat = 12;
        KeyRepeat = 3;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        "com.apple.keyboard.fnState" = true;
        "com.apple.sound.beep.volume" = 0.5;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        "com.apple.trackpad.scaling" = 0.5;
        "com.apple.springing.enabled" = true;

        # Disable “natural” (Lion-style) scrolling
        "com.apple.swipescrolldirection" = false;

        _HIHideMenuBar = false;
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      # Firewall
      alf = {
        globalstate = 1;
        allowsignedenabled = 1;
        allowdownloadsignedenabled = 0;
        loggingenabled = 1;
        stealthenabled = 1;
      };

      # Dock and Mission Control
      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        dashboard-in-overlay = true;
        enable-spring-load-actions-on-all-items = true;
        expose-group-by-app = true;
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        showhidden = true;
        show-recents = true;
        static-only = false;
        magnification = false;
        tilesize = 64;

        # Disable all hot corners
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "icnv";
        AppleShowAllExtensions = true;
        CreateDesktop = true;
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
      };

      # Login and lock screen
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      screensaver.askForPassword = false;

      # one space spans across all physical displays
      spaces.spans-displays = true;

      trackpad = {
        TrackpadRightClick = true;
      };

      universalaccess = {
        mouseDriverCursorSize = 2.0;
        closeViewScrollWheelToggle = true;
      };
    };
  };
}
