{ config, lib, ... }: {
  options = {
    fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      fish = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
        enable = config.fish.enable;

        functions = {
          # https://fishshell.com/docs/current/cmds/function.html
        };

        shellAbbrs = {
          b = "bundle";
          be = "bundle exec";

          c = "clear";

          d = "docker";
          dc = "docker compose";
          dcr = "docker compose run --rm --use-aliases";
          dcrs = "docker compose run --rm --use-aliases --service-ports";

          md = "mkdir -pv";
          reflake = "darwin-rebuild switch --flake";

          tn = "tmux-sessionizer";

          v = "nvim";
          vf = "nvim .";
        };

        shellAliases = {
          "..." = "cd ../..";
        };

        interactiveShellInit = ''
fish_vi_key_bindings

set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block

set -U fish_user_paths ~/.local/bin $fish_user_paths
set -U fish_user_paths ~/.orbstack/bin $fish_user_paths
        '';
      };
    };
  };
}
