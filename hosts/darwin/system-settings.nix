{ username, ... }: {
  system.primaryUser = username;
  system.defaults.ActivityMonitor.IconType = 6;

  system.defaults.dock.autohide = true;
  system.defaults.dock.largesize = 16;
  system.defaults.dock.mineffect = "scale";
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;
  system.defaults.dock.tilesize = 48;
  system.defaults.dock.autohide-delay = 0.1;
  system.defaults.dock.autohide-time-modifier = 0.1;
 
  # Hot corner action for bottom left corner.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner
  system.defaults.dock.wvous-bl-corner = 14;
  # Hot corner action for bottom right corner.
  system.defaults.dock.wvous-br-corner = 1;
  # Hot corner action for top left corner.
  system.defaults.dock.wvous-tl-corner = 1;
  # Hot corner action for top right corner.
  system.defaults.dock.wvous-tr-corner = 1;

  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;

  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.CreateDesktop = false;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;

  system.defaults.finder.ShowExternalHardDrivesOnDesktop = false;
  system.defaults.finder.ShowHardDrivesOnDesktop = false;
  system.defaults.finder.ShowMountedServersOnDesktop = false;
  system.defaults.finder.ShowRemovableMediaOnDesktop = false;

  system.defaults.loginwindow.GuestEnabled = false;

  system.defaults.screensaver.askForPassword = true;
  system.defaults.screensaver.askForPasswordDelay = 1;

  system.defaults.trackpad.ActuationStrength = 0;
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.FirstClickThreshold = 1;
  system.defaults.trackpad.SecondClickThreshold = 1;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.defaults.hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";

  system.defaults.iCal."first day of week" = "Monday";
  system.defaults.iCal."TimeZone support enabled" = true;

  system.defaults.menuExtraClock.FlashDateSeparators = true;
  system.defaults.menuExtraClock.Show24Hour = true;
  system.defaults.menuExtraClock.ShowAMPM = false;
  system.defaults.menuExtraClock.ShowDate = 1;
}
