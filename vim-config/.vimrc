" Config desription at
" https://medium.com/@edominguez.se/vim-101-a-comprehensive-guide-to-using-vim-like-an-ide-1-3-vimrc-d484cc41fc2
" https://medium.com/geekculture/fuzzy-searchhow-to-set-up-vim-in-2021-2-3-b8eae1b77497

syntax on

set fileformat=unix
set encoding=UTF-8

set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smarttab
set expandtab

set nowrap
" set list
" set listchars=eol:.,tab:>-,trail:~,extends:>,precedes:<

set cursorline
set number
set relativenumber
set scrolloff=8
set signcolumn=yes

set showcmd
set noshowmode
set conceallevel=1

set noerrorbells visualbell t_vb=
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set clipboard=unnamed

set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <CR> :noh<CR><CR>:<backspace>

so $DOTFILES_PATH/vim-config/plugins.vim
so $DOTFILES_PATH/vim-config/plugin-config.vim
so $DOTFILES_PATH/vim-config/autoclose.vim

set textwidth=119

set mouse=a
