{
  description = "RTi Air Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{self, nix-darwin, nixpkgs, ...}:
    let
      username = "rti";

      stableOverlay = final: _prev: {
        stable = import inputs.nixpkgs-stable {
          system = "aarch64-darwin";
        };
      };

      homebrewConfig = {
        nix-homebrew = {
          # Install Homebrew under the default prefix
          enable = true;
          autoMigrate = true;

          # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
          enableRosetta = true;

          # User owning the Homebrew prefix
          user = username;

          # Optional: Enable fully-declarative tap management
          # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
          mutableTaps = false;
          # Optional: Declarative tap management
          taps = {
            "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
          };
        };
      };

      configuration = { pkgs, config, ... }: {
        nixpkgs = {
          hostPlatform = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [
            stableOverlay
          ];
        };

        users.users.rti= {
          name = username;
          home = "/Users/${username}";
        };

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            ack
            bat
            bottom
            delta
            du-dust
            emacs
            eza
            fd
            fzf
            gcc
            git
            glow
            gnumake
            hledger
            jq
            jnv
            k9s
            marksman
            mise
            mkalias
            mysql
            neofetch
            neovim
            obsidian
            ripgrep
            tldr
            tree-sitter
            tmux
            vim
            stable.wezterm
            wget
            yq
          ];

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs = {
          zsh = {
            enable = true;  # default shell on catalina
          };
        };
        # programs.fish.enable = true;

        homebrew = {
          enable = true;

          brews = [
            "mas"
          ];

          casks = [
            "bruno"
            "logseq"
            "nikitabobko/tap/aerospace"
            "notion"
            "orbstack"
          ];

          masApps = {
            "Endel" = 1346247457;
            "Flow" = 1423210932;
            "Keynote" = 409183694;
            "Numbers" = 409203825;
            "OpenIn" = 1643649331;
            "Owly" = 882812218;
            "Pages" = 409201541;
            "Slack" = 803453959;
            "System color picker" = 1545870783;
            "Telegram" = 747648890;
            "Wireguard" = 1451685025;
            "Yubico Authenticator" = 1497506650;

            # Safari extensions
            "1password for Sarafi" = 1569813296;
            "Hush" = 1544743900;
            "Noir" = 1592917505;
            "Simplelogin" = 1494051017;
            "SocialFocus" = 1661093205;
            "Surfingkeys" = 1609752330;
            "UnTrap youtube" = 1637438059;
            "Wipr" = 1320666476;
          };

          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

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

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
        # The platform the configuration will be used on.

      };
    in
      {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#air
      darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          inputs.nix-homebrew.darwinModules.nix-homebrew
          homebrewConfig
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
