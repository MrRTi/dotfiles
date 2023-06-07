# The home.packages option allows you to install Nix packages into your
# environment.
  
pkgs: with pkgs; [
  # # Adds the 'hello' command to your environment. It prints a friendly
  # # "Hello, world!" when run.
  # pkgs.hello

  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')
  (nerdfonts.override { fonts = ["JetBrainsMono"]; })
  git
  tmux
  curl
  #
  # Shell prompt tools
  gitstatus
  #
  # Home manager dir related shells
  lorri
  direnv
  #
  # Neovim essentials
  ripgrep
  lazygit
  tree
  tree-sitter
  #
  neovim
  #
  # CLI tools 
  tealdeer
  fzf
  broot
  htop
  bottom
  bat
  jq
  lsd
  # Containerization
  # docker
  # docker-compose
  podman
  podman-compose
  kubectl
  k9s
  packer
  # Terminal
  kitty
  # Programming tools
  just
  #
  # Plaintext banking
  hledger
  hledger-ui
  hledger-web
]

