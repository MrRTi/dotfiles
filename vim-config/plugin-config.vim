" set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
hi Normal guibg=NONE ctermbg=NONE
let g:terminal_ansi_colors = [
    \ '#282828', '#cc241d', '#98971a', '#d79921',
    \ '#458588', '#b16286', '#689d6a', '#a89984',
    \ '#928374', '#fb4934', '#b8bb26', '#fabd2f',
    \ '#83a598', '#d3869b', '#8ec07c', '#ebdbb2',
\]

nnoremap <C-t> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
set wildignore+=*.DS_Store,*.min.*
" autocmd BufWinEnter * silent NERDTreeMirror.

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'ruby': ['rubocop', 'reek', 'brakeman', 'rails_best_practices', 'debride'],
\   'slim': ['slim-lint'],
\}
let g:ale_fix_on_save = 1
let g:ale_disable_lsp = 1

" :CocInstall coc-solargraph coc-tsserver coc-tabnine coc-pyright coc-html coc-css coc-sh coc-json 
set shortmess+=c
" :CocConfig "diagnostic.displayByAle": true
  
nmap <F8> :TagbarToggle<CR>

let g:indentLine_color_term = 239
let g:indentLine_bgcolor_term = 202
" let g:indentLine_color_gui = '#A4E57E'
" let g:indentLine_bgcolor_gui = '#FF5F00'
