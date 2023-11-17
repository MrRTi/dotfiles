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
  ack
  autojump
  bat
  btop
  broot
  colordiff
  curl
  fd
  fontconfig
  fzf
  git
  hledger
  hledger-ui
  hledger-web
  htop
  jq
  just
  k9s
  kubectl
  lazygit
  lsd
  neovim
  nixfmt
  nodejs_20
  nodePackages.neovim
  openssh
  pandoc
  qemu
  ripgrep
  ruby
  shellcheck
  snappy
  tealdeer
  terraform
  tmux
  tree
  tree-sitter
]
