" my simple vim config
" justfly <justfly.py@gmail.com>
" enjoy!
"

call plug#begin('~/.config/nvim/plugged')
" LeaderF
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" language client
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'Shougo/echodoc.vim'
Plug 'ervandew/supertab'
" lightline
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" brackets
Plug 'Raimondi/delimitMate'
Plug 'luochen1990/rainbow'
" show tralling whitespace
Plug 'bronson/vim-trailing-whitespace'
" global search
Plug 'rking/ag.vim'
Plug 'yssl/QFEnter'
" language enhancement
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" colors
Plug 'NLKNguyen/papercolor-theme'
call plug#end()

let mapleader=','

" LeaderF
let g:Lf_WindowHeight = 0.3
let g:Lf_MruMaxFiles = 15
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_CommandMap = {'<C-]>': ['<C-V>'], '<C-X>': ['<C-H>']}
let g:Lf_DefaultMode = 'FullPath'
nmap <silent> <c-p> :LeaderfFile<cr>
nmap <silent> <c-u> :LeaderfMruCwd<cr>
nmap <silent> <c-y> :LeaderfBuffer<cr>
nnoremap <silent> <leader>f :LeaderfFunction<cr>
nnoremap <silent> <leader>t :LeaderfBufTag<cr>

" language client
let g:LanguageClient_serverCommands = {
            \ 'go' : ['go-langserver', '-gocodecompletion', '-diagnostics'],
            \ 'python': ['/Users/justfly/.pyenv/versions/3.6.5/bin/pyls'],
            \ 'c' : ['cquery', '--log-file=/tmp/cquery.log', '--init={"cacheDirectory":"/tmp/cquery/", "completion": {"filterAndSort": false}}'],
    \ }
nnoremap <silent> <leader>d :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient#textDocument_references()<CR>:lopen<CR>
nnoremap <silent> <leader>h :call LanguageClient#textDocument_hover()<CR>
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
let g:lightline.colorscheme = 'PaperColor'

"vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_modified = '!'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_sign_column_always = 0

" DelimitMate
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
au FileType markdown let b:delimitMate_nesting_quotes = ["`"]

" rainbow
let g:rainbow_active = 1

" remove trailing whitespace
map <leader>s :FixWhitespace<cr>

" ag
nnoremap <silent> <leader>* :Ag <c-r><c-w><cr>
let g:ag_apply_qmappings = 1
let g:ag_apply_lmappings = 1

" qfenter
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['<C-V>']
let g:qfenter_keymap.hopen = ['<C-H>']
let g:qfenter_keymap.topen = ['<C-T>']

" basic config
syntax on
syntax enable
set termguicolors
set background=dark
colorscheme PaperColor
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

" window switch
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l
nnoremap <silent><leader>q :bd<cr>
nnoremap <silent><leader>w :close<cr>
nnoremap <silent><leader>x :qall<cr>
