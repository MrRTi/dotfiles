{ pkgs, config, ... }: {
  system.defaults = {
    dock = {
      autohide = false;
      show-recents = false;
      persistent-apps = [
        "/Applications/ChatGPT.app/"
        "/System/Applications/Calendar.app"
        "/System/Applications/Reminders.app"
        "/System/Applications/Notes.app"
        "/System/Applications/Mail.app"
        "/Applications/Proton Mail.app"
        "${pkgs.wezterm}/Applications/WezTerm.app"
        "/Applications/Arc.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/Applications/Telegram.app"
        "/Applications/LOOP.app"
      ];
    };
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
    };
    loginwindow.GuestEnabled=false;
    NSGlobalDomain = {
      AppleICUForce24HourTime=true;
      AppleMetricUnits=1;
      KeyRepeat=2;
    };
  };

  # Add apps to Spotlight
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

}
