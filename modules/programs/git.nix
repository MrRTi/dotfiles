{ config, lib, ... }: {
  options = {
    git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable module";
        default = true;
      };
    };
  };

  config = {
    programs ={
      git = {
        enable = config.git.enable;

        extraConfig = {
          commit.gpgSign = true;
          gpg.format = "ssh";
          gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };

        includes = [
          {
            path = "~/.git-includes.gitconfig";
          }
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
          current-branch = "rev-parse --abbrev-ref HEAD";
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
          git_repo_name = "basename -s .git (git config --get remote.origin.url)";
          # NOTE: Deprecated. Only for bare repos
          git_worktree_bare = "git worktree list | grep 'bare' | awk '{print $1}'";
          git_clone_with_worktree = ''
            git clone "$argv[1]" "$argv[2]"/main
            cd "$argv[2]"
            touch .envrc
            echo "source_up" >> .envrc
            direnv allow
            cd main
          '';
          git_worktree_base = ''
            set git_dir (git rev-parse --show-toplevel 2>/dev/null) || if test -d ./main/.git
              # NOTE: to be able to use git command in root project folder
              cd main
              set git_dir (git rev-parse --show-toplevel)
            end

            if test -d "$git_dir/.git"
              dirname $git_dir
              return 0
            end

            if test -f "$git_dir/.git"
              cat .git | awk '{print $2}' | string split '/.git/worktrees' | head -n1 | xargs dirname
              return 0
            end

            echo "Not git repository"
            return 1
          '';
          git_branch_query = ''
            git branch | \
            sed -r "s:\* (.*):\1 [exists]:" | \
            awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | \
            fzf --print-query --ansi --query "$argv[1]" | \
            tail -n 1 | \
            awk '{print $1}'
          '';
          git_worktree_add_query = ''
            set branch (string trim (git_branch_query "$argv[1]"))
            echo "Creating worktree at '$branch'"
            if git branch | grep -q $branch
              git worktree add (git_worktree_base)/$branch $branch
            else
              git worktree add (git_worktree_base)/$branch -b $branch
            end

            cd (git_worktree_base)/$branch
          '';
          git_worktree_select = ''
            set root (git_worktree_base)

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
          git_worktree_remove = ''
            git worktree list | awk '{print $1}' | fzf --multi | while read line
            git worktree remove --force $line
            end
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
          gpu = "git push -u origin (git current-branch)";
          gres = "git reset --hard origin/(git current-branch)";
          gpf = "git push --force origin (git current-branch)";
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
          gwrfzf = "git_worktree_remove";
        };
      };
    };
  };
}
