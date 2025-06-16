{ username, ... }: {
  system.primaryUser = username;
  system.defaults.ActivityMonitor.IconType = 6;

  system.defaults.dock.autohide = false;
  system.defaults.dock.largesize = 16;
  system.defaults.dock.magnification = false;
  system.defaults.dock.mineffect = "scale";
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "right";
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;
  system.defaults.dock.tilesize = 36;
 
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
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;

  system.defaults.loginwindow.GuestEnabled = false;

  system.defaults.screensaver.askForPassword = true;
  system.defaults.screensaver.askForPasswordDelay = 1;

  system.defaults.trackpad.ActuationStrength = 0;
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.FirstClickThreshold = 1;
  system.defaults.trackpad.SecondClickThreshold = 1;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
