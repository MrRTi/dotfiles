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

        enableTransience = true;

        settings = {
          add_newline = false;

          scan_timeout = 30;
          follow_symlinks = true;

          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$custom"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$docker_context"
            "$ruby"
            "$python"
            "$line_break"
            "$shell"
            "$character"
          ];

          directory = {
            truncation_symbol = ".../";
            repo_root_style = "underline yellow";
            fish_style_pwd_dir_length = 1;
            style = "yellow";
            read_only = " ";
          };

          git_branch = {
            symbol = " ";
            style = "blue";
          };

          git_status = {
            ahead = "⇡$count";
            diverged = "⇕⇡$ahead_count⇣$behind_count";
            behind = "⇣$count";
            style = "red";
          };

          character = {
            success_symbol = "[>](bold green)";
            error_symbol = "[x](red)";
            vimcmd_symbol = "[N](blue)";
            vimcmd_replace_one_symbol = "[R](red)";
            vimcmd_replace_symbol = "[R](red)";
            vimcmd_visual_symbol = "[V](purple)";
          };

          docker_context = {
            symbol = "󰡨 ";
          };

          ruby = {
            symbol = " ";
          };

          custom.git_base = {
            command = "git_repo_name";
            require_repo = true;
            when = true;
            description = "Show git repository base folder. Helpful when using worktrees and shorten pwd";
            style = "bold blue";
            symbol = " ";
            format = "at [$symbol($output)]($style) ";
          };
        };
      };
    };
  };
}
