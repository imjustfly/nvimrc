" my simple vim config
" justfly <justfly.py@gmail.com>
" enjoy!
"

call plug#begin('~/.config/nvim/plugged')
" fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" language client
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'Shougo/echodoc.vim'
Plug 'ervandew/supertab'
" lightline
Plug 'itchyny/lightline.vim'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" brackets
Plug 'Raimondi/delimitMate'
Plug 'luochen1990/rainbow'
" comment
Plug 'scrooloose/nerdcommenter'
" show tralling whitespace
Plug 'bronson/vim-trailing-whitespace'
" language enhancement
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" colors
Plug 'morhetz/gruvbox'
call plug#end()

let mapleader=' '

" fzf
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-h': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1

" language client
let g:LanguageClient_serverCommands = {
            \ 'go' : ['go-langserver', '-gocodecompletion', '-diagnostics'],
            \ 'python': ['/Users/justfly/.pyenv/versions/3.6.5/bin/pyls'],
            \ 'c' : ['cquery', '--log-file=/tmp/cquery.log', '--init={"cacheDirectory":"/tmp/cquery/", "completion": {"filterAndSort": false}}'],
    \ }
let g:LanguageClient_loggingFile = '/tmp/languageclient.log'
au BufWritePre *.h,*.c,*.go,*.py :call LanguageClient_textDocument_formatting()

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" echodoc
let g:echodoc_enable_at_startup = 1

" SuperTab
let g:SuperTabDefultCompletionType='context'
let g:SuperTabDefaultCompletionType = '<C-X><C-U>'
let g:SuperTabRetainCompletionType=2

" lightline
let g:lightline = {}
let g:lightline.component_function = { 'gitbranch': 'fugitive#head' }
let g:lightline.active = {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             ['readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ]]
      \}
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.colorscheme = 'jellybeans'

"vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_sign_modified = '!'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_sign_column_always = 0

" DelimitMate
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
au FileType markdown let b:delimitMate_nesting_quotes = ["`"]

" rainbow
let g:rainbow_active = 1

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

" basic config
syntax on
syntax enable
set termguicolors
set background=dark
colorscheme gruvbox
set ai
set re=1
set bs=2
set noshowmode
set showmatch
set laststatus=2
set autoread
set modeline
set ignorecase
set fileencodings=utf-8
set hls
set helplang=cn
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=10
set hidden
set splitbelow
set splitright
set signcolumn=yes
set fillchars+=vert:\|
set expandtab
set shiftwidth=4
set tabstop=4

" language related configs
filetype plugin indent on
au WinNew * set cc=
au FileType c set cc=80
au BufRead,BufNewFile *.h,*.c set filetype=c
au FileType python setlocal et sta sw=4 sts=4
au FileType python setlocal foldmethod=indent
au FileType python set cc=79
au FileType go setlocal noexpandtab
au FileType vue set shiftwidth=2 tabstop=2
au FileType javascript set shiftwidth=2 tabstop=2
au FileType qf nnoremap <buffer> <Esc> :q<Enter>
au QuickFixCmdPost *grep* cwindow

" relative line number
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber

" global key bindings
"
" windows
nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
nnoremap <leader>wh <c-w>h
nnoremap <leader>wl <c-w>l
nnoremap <silent><leader>wd :close<cr>

" buffers
nnoremap <silent><leader>bd :bd<cr>

" languages
nnoremap <silent><leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent><leader>lr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent><leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent><leader>ls :LanguageClientStart<CR>

" jumps
nnoremap <silent><leader>fw :Windows<cr>
nnoremap <silent><leader>fb :Buffers<cr>
nnoremap <silent><leader>fp :Files<cr>
nnoremap <silent><leader>ff :BTags<cr>
nnoremap <silent><leader>fm :Marks<cr>
nnoremap <silent><leader>fc :Commands<cr>
nnoremap <silent><leader>fg :Ag<space>
nnoremap <silent><leader>f* :Ag <c-r><c-w><cr>

" git
nnoremap <silent><leader>gs :Gstatus<cr>
nnoremap <silent><leader>gc :Gcommit<cr>
nnoremap <silent><leader>gpl :Gpull<cr>
nnoremap <silent><leader>gps :Gpush<cr>:copen<cr>

" comment
imap <C-c> <plug>NERDCommenterInsert

" vim
nnoremap <silent><leader>vq :qall<cr>
nnoremap <silent><leader>vm :messages<cr>
nnoremap <leader>vh :help<space>
