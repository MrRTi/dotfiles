# You can also manage environment variables but you will have to manually
# source
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/yc-user/etc/profile.d/hm-session-vars.sh
#
# if you don't want to manage your shell through Home Manager.
{
  EDITOR = "nvim";
  ZSH_TMUX_CONFIG = ~/.config/tmux/tmux.conf;
  HISTFILE = ~/.zsh_history;
}
