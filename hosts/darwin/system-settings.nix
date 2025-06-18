{ username, ... }: {
  system = {
    primaryUser = username;

    defaults = {
      ActivityMonitor = {
        IconType = 6;
      };

      controlcenter = {
        BatteryShowPercentage = false;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.1;
        autohide-time-modifier = 0.1;
        tilesize = 48;
        largesize = 16;
        orientation = "bottom";
        mineffect = "scale";
        mru-spaces = false;
        show-recents = false;
        showhidden = true;

        # Hot corner action for bottom left corner.
        # https://daiderd.com/nix-darwin/manual/index.html#opt-defaults.dock.wvous-bl-corner
        wvous-bl-corner = 14;
        # Hot corner action for bottom right corner.
        wvous-br-corner = 1;
        # Hot corner action for top left corner.
        wvous-tl-corner = 1;
        # Hot corner action for top right corner.
        wvous-tr-corner = 1;
      };

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        AppleMetricUnits = 1;
        AppleShowScrollBars = "Always";
        KeyRepeat = 2;
        _HIHideMenuBar = false;
      };

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;

        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 1;
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };

      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        TrackpadRightClick = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
      };

      hitoolbox = {
        AppleFnUsageType = "Show Emoji & Symbols";
      };

      iCal = {
        "first day of week" = "Monday";
        "TimeZone support enabled" = true;
      };

      menuExtraClock = {
        FlashDateSeparators = true;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1;
        ShowDayOfWeek = true;
      };

      WindowManager = {
        EnableTiledWindowMargins = true;
        EnableTilingByEdgeDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
