{ pkgs, ... }:
{
  imports = [
    ../../../darwin/dock.nix
  ];

  macosDock.enable = true;
  macosDock.entries = [
    { path = "${pkgs.chatgpt}/Applications/ChatGPT.app"; }
    { path = ""; options = "--type small-spacer";}
    { path = "/System/Applications/Calendar.app"; }
    { path = "/System/Applications/Reminders.app"; }
    { path = "/System/Applications/Notes.app"; }
    { path = "${pkgs.obsidian}/Applications/Obsidian.app"; }
    { path = ""; options = "--type small-spacer";}
    { path = "${pkgs.wezterm}/Applications/WezTerm.app"; }
    { path = ""; options = "--type small-spacer";}
    { path = "${pkgs.arc-browser}/Applications/Arc.app"; }
    { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }
    { path = ""; options = "--type small-spacer";}
    { path = "/System/Applications/Mail.app"; }
    { path = "/Applications/Telegram.app"; }
    { path = "/Applications/LOOP.app"; }
    { path = ""; options = "--type small-spacer";}
  ];
}
