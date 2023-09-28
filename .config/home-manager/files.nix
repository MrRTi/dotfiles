# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
  
{
  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';
  ".config/tmux/tmux.conf".source = ~/.dotfiles/.config/tmux/tmux.conf;
  ".config/alacritty/alacritty.yml".source = ~/.dotfiles/.config/alacritty/alacritty.yml; 
  ".config/lsd".source = ~/.dotfiles/.config/lsd;
  ".zsh_plugins.txt".source = ~/.dotfiles/zsh-config/.zsh_plugins.txt;
}

