function op_run_with_env
  set -l env_file (git_worktree_base)/.env
  op run --no-masking --env-file=$env_file -- $argv
end
