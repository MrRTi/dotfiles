{ config, lib, ... }: {
  options = {
    git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
      config = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name for git";
        };
        personal = {
          folderPath = lib.mkOption {
            type = lib.types.path;
            description = "Path to personal directory";
          };
          email = lib.mkOption {
            type = lib.types.str;
            description = "Email for personal git";
          };
          signingKey = lib.mkOption {
            type = lib.types.str;
            description = "Public key for signing";
          };
        };
        work = {
          folderPath = lib.mkOption {
            type = lib.types.path;
            description = "Path to work directory";
          };
          email = lib.mkOption {
            type = lib.types.str;
            description = "Email for work git";
          };
          signingKey = lib.mkOption {
            type = lib.types.str;
            description = "Public key for signing";
          };
        };
      };
    };
  };

  config = {
    programs ={
      git = {
        enable = config.git.enable;

        userName = config.git.config.name;
        userEmail = config.git.config.personal.email;

        extraConfig = {
          commit.gpgSign = true;
          gpg.format = "ssh";
          gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          user.signingKey = config.git.config.personal.signingKey;
        };

        includes = [
        #   {
        #     contents = {
        #       user = {
        #         email = config.git.config.work.email;
        #         signingKey = config.git.config.work.signingKey;
        #       };
        #     };
        #     condition = "gitdir:${config.git.config.work.folderPath}/**";
        #   }
        ];

        ignores = [
          ".DS_Store"
          ".envrc"
          "shell.nix"
          "\#*\#"
          ".\#*"
          "*~"
          ".mise.toml"
          "*.swp"
        ];

        lfs = {
          enable = true;
        };

        maintenance = {
          enable = true;
          timers = {
            weekly = "Sunday 01::00";
          };
        };

        aliases = {
          cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop\\|main' | xargs -n 1 -r git branch -d";
          log-pretty = "log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        };

        delta = {
          enable = true;
          options = {
            navigate = true;
            side-by-side = true;
            line-numbers = true;
            features = "side-by-side line-numbers decorations";
            decorations = {
              commit-decoration-style = "bold yellow box ul";
              file-style = "bold yellow ul";
              hunk-header-decoration-style = "cyan box";
            };
            whitespace-error-style = "22 reverse";
          };
        };

        extraConfig = {
          init.defaultBranch = "main";

          core = {
            editor = "nvim";
            autocrlf = "input";
          };
          credential.helper = "helper = cache --timeout=3600
            ";
          help.autocorrect = 1;
          interractive.diffFilter = "delta --color-only";
          merge.conflictstyle = "diff3";
          diff.colorMoved = "default";
          color.ui = true;
          pull.rebase = true;
          push.default = "current";
          rebase.autoStash = true;
        };
      };

      fish = lib.mkIf (config.git.enable && config.fish.enable) {
        functions = {
          git_worktree_root = "git worktree list | grep 'bare' | awk '{print $1}'";
          git_branch_query = ''
            git branch | \
            sed -r "s:\+ (.*):\1 [exists]:" | \
            awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | \
            fzf --print-query --ansi --query "$argv[1]" | \
            tail -n 1
          '';
          git_worktree_add_query = ''
            set branch (git_branch_query "$argv[1]")
            echo "Creating worktree at $branch"
            if git branch | grep -q $branch
              git worktree add (git_worktree_root)/$branch $branch
            else
              git worktree add (git_worktree_root)/$branch -b $branch
            end

            cd (git_worktree_root)/$branch
          '';
          git_worktree_select = ''
            set root (git_worktree_root)

            git worktree list |
            awk '{printf "\x1b[34m %s\x1b[0m\t\x1b[33m%s\x1b[0m\n", ($3 == "" ? "(root)" : $3), $1}' |
            begin
                if test -n "$root"
                    sed "s:$root:󰾛 :"
                else
                    cat
                end
            end |
            sed "/ (root)*/d" |
            column -t |
            fzf --ansi --query "$argv[1]" |
            begin
                if test -n "$root"
                    sed "s:󰾛  :$root:"
                else
                    cat
                end
            end
          '';
          git_worktree_switch = ''
            set worktree_path (git_worktree_select $argv[1] | awk '{print $3}')
            if test -z "$worktree_path"
              return
            end
            cd "$worktree_path"
          '';
        };
        shellAbbrs = {
          g = "git";
          ga = "git add";
          gb = "git branch";
          gc = "git commit";
          gco = "git checkout";
          gd = "git diff";
          glol = "git log-pretty";
          gpu = "git push -u origin (git rev-parse --abbrev-ref HEAD)";
          grup = "git remote update";
          gs = "git status";
          gw = "git worktree";
          gwa = "git worktree add";
          gwl = "git worktree list";
          gwr = "git worktree remove";
          gwrf = "git worktree remove --force";
        };

        shellAliases = {
          gwaq = "git_worktree_add_query";
          gws = "git_worktree_switch";
        };
      };
    };
  };
}
