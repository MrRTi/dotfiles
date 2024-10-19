{ config, lib, ... }: {
  options = {
    starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs = {
      starship = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
        enable = config.starship.enable;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;

        enableTransience = false;

        settings = {
          add_newline = false;

          scan_timeout = 30;
          follow_symlinks = true;

          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$shell"
            "$character"
          ];

          directory = {
            truncation_symbol = ".../";
            repo_root_style = "bold underline bright-yellow";
            fish_style_pwd_dir_length = 1;
            style = "yellow";
            read_only = " ";
          };

          git_branch = {
            symbol = " ";
            style = "bold blue";
          };

          git_status = {
            ahead = "⇡$count";
            diverged = "⇕⇡$ahead_count⇣$behind_count";
            behind = "⇣$count";
          };

          character = {
            success_symbol = "[>](green)";
            error_symbol = "[x](red)";
            vimcmd_symbol = "[N](bold green)";
            vimcmd_replace_one_symbol = "[R](bold purple)";
            vimcmd_replace_symbol = "[R](bold purple)";
            vimcmd_visual_symbol = "[V](bold yellow)";
          };
        };
      };
    };
  };
}
