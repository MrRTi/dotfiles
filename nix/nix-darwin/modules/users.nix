{ pkgs, username, ... }: {
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;

    # List packages installed in profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    packages = with pkgs;
      [
        ack
        bat
        bottom
        cmake
        delta
        direnv
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
  };
}
