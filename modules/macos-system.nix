{ pkgs, config, username, ... }: {
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

  # system.defaults.dock.persistent-apps = [
  #   "/Applications/ChatGPT.app/"
  #   "/System/Applications/Calendar.app"
  #   "/System/Applications/Reminders.app"
  #   "/System/Applications/Notes.app"
  #   "/System/Applications/Mail.app"
  #   # "/Applications/Proton Mail.app"
  #   "${pkgs.wezterm}/Applications/WezTerm.app"
  #   # "/Applications/Arc.app"
  #   "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
  #   "/Applications/Telegram.app"
  #   "/Applications/LOOP.app"
  # ];

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

  # Add apps to Spotlight
  # system.activationScripts.applications.text = let
  #   env = pkgs.buildEnv {
  #     name = "system-applications";
  #     paths = config.environment.systemPackages;
  #     pathsToLink = "/Applications";
  #   };
  # in
  #   pkgs.lib.mkForce ''
  #     # Set up applications.
  #     echo "setting up /Applications..." >&2
  #     rm -rf /Applications/Nix\ Apps
  #     mkdir -p /Applications/Nix\ Apps
  #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #     while read -r src; do
  #       app_name=$(basename "$src")
  #       echo "copying $src" >&2
  #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  #     done
  #   '';

}
