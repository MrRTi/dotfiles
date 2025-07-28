{ ... }:
{
  imports = [
    ./mas/safari-qol.nix
  ];

  homebrew.masApps = {
    "Keynote" = 409183694;
    "Numbers" = 409203825;
    "Pages" = 409201541;
    "System color picker" = 1545870783;

    "Shadowrocket" = 932747118;

    "Endel" = 1346247457;
    "Flow" = 1423210932;
    "Owly" = 882812218;
    "Slack" = 803453959;
    "Telegram" = 747648890;
    "Wireguard" = 1451685025;
    "Yubico Authenticator" = 1497506650;
    "Little Snitch Mini" = 1629008763;
  };
}
