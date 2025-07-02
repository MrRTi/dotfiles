{ username, ... }: {
  system = {
    primaryUser = username;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      # Use https://github.com/joshryandavis/defaults2nix for system settings dump
      CustomUserPreferences = {
        NSGlobalDomain = import ./system.defaults/NSGlobalDomain.nix;
        "app.loshadki.OpenIn.v4" = import ./system.defaults/app.loshadki.OpenIn.v4.nix;
        "com.amethyst.Amethyst" = import ./system.defaults/com.amethyst.Amethyst.nix;
        "com.apple.ActivityMonitor" = import ./system.defaults/com.apple.ActivityMonitor.nix;
        "com.apple.AppleMultitouchMouse" = import ./system.defaults/com.apple.AppleMultitouchMouse.nix;
        "com.apple.AppleMultitouchTrackpad" = import ./system.defaults/com.apple.AppleMultitouchTrackpad.nix;
        "com.apple.HIToolbox" = import ./system.defaults/com.apple.HIToolbox.nix;
        "com.apple.SoftwareUpdate" = import ./system.defaults/com.apple.SoftwareUpdate.nix;
        "com.apple.WindowManager" = import ./system.defaults/com.apple.WindowManager.nix;
        "com.apple.controlcenter" = import ./system.defaults/com.apple.controlcenter.nix;
        "com.apple.controlstrip" = import ./system.defaults/com.apple.controlstrip.nix;
        "com.apple.dock" = import ./system.defaults/com.apple.dock.nix;
        "com.apple.finder" = import ./system.defaults/com.apple.finder.nix;
        "com.apple.iCal" = import ./system.defaults/com.apple.iCal.nix;
        "com.apple.loginwindow" = import ./system.defaults/com.apple.loginwindow.nix;
        "com.apple.menuextra.clock" = import ./system.defaults/com.apple.menuextra.clock.nix;
        "com.apple.menuextra.textinput" = import ./system.defaults/com.apple.menuextra.textinput.nix;
        "com.apple.screensaver" = import ./system.defaults/com.apple.screensaver.nix;
        "com.apple.systempreferences" = import ./system.defaults/com.apple.systempreferences.nix;
        "com.fiplab.owly" = import ./system.defaults/com.fiplab.owly.nix;
        "com.raycast.macos" = import ./system.defaults/com.raycast.macos.nix;
        "io.tailscale.ipn.macos" = import ./system.defaults/io.tailscale.ipn.macos.nix;
      };
    };
  };
}
