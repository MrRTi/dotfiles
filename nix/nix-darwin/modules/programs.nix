{ pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # These packages are available system wide
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

  # # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
}
