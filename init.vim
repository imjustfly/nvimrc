" my simple vim config
" justfly <justfly.py@gmail.com>
" enjoy!
"
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" language client
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" completion
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'roxma/nvim-yarp'
Plug 'Shougo/echodoc.vim'
Plug 'ervandew/supertab'
" lightline
Plug 'itchyny/lightline.vim'
" Git
Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'
" brackets
Plug 'Raimondi/delimitMate'
" comment
Plug 'scrooloose/nerdcommenter'
" show and fix tralling whitespace
Plug 'bronson/vim-trailing-whitespace'
" language enhancement
Plug 'cespare/vim-toml', { 'for': 'toml' }
" colors
Plug 'morhetz/gruvbox'
" pos navigator
Plug 'imjustfly/vim-navigator'
call plug#end()

" leader key
let mapleader=' '

" leaderf
let g:Lf_ShortcutF = "<leader>ff"
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"}
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>

" language client
let g:LanguageClient_serverCommands = {
            \ 'go' : ['bingo', '-disable-func-snippet', '-diagnostics-style', 'onsave'],
            \ 'python' : ['pyls'],
            \ 'c' : ['cquery', '--log-file=/tmp/cquery.log', '--init={"cacheDirectory":"/tmp/cquery/", "completion": {"filterAndSort": false}}'],
    \ }
let g:LanguageClient_loggingFile = '/tmp/languageclient.log'
let g:LanguageClient_hoverPreview = 'Always'
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
let g:lightline.component = {
    \    'winnr': '%{nr2char(9311 + winnr())} ',
    \    'filename': '✐ %t',
    \    'gitbranch': ' %{gitbranch#name()}',
    \ }
let g:lightline.active = {
    \    'left': [ [ 'winnr', 'mode', 'paste' ],
    \              [ 'gitbranch' ],
    \              ['readonly', 'filename', 'modified' ] ],
    \    'right': [ [ 'lineinfo' ],
    \               [ 'fileformat', 'fileencoding', 'filetype' ]]
    \ }
let g:lightline.inactive = {
    \ 'left': [ [ 'winnr' ],
    \           [ 'filename' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ] ] }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.colorscheme = 'gruvbox'

"vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_sign_modified = '!'
let g:gitgutter_sign_modified_removed = '±'
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

let g:gruvbox_contrast_dark = 'hard'

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
set switchbuf=useopen,usetab
set list
set listchars=tab:▶‧,nbsp:%,space:‧,eol:↲,extends:►,precedes:◄,nbsp:×
set nowrap
set ss=0

" language related configs
filetype plugin indent on
au BufRead,BufNewFile *.h,*.c set filetype=c
au BufNewFile,BufRead go.mod if getline(1) =~ '^module.*' | set filetype=gomod |  endif
au FileType python setlocal et sta sw=4 sts=4
au FileType python setlocal foldmethod=indent
au FileType markdown set nowrap
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
nnoremap <leader>w1 1<c-w><c-w>
nnoremap <leader>w2 2<c-w><c-w>
nnoremap <leader>w3 3<c-w><c-w>
nnoremap <leader>w4 4<c-w><c-w>
nnoremap <leader>w5 5<c-w><c-w>
nnoremap <leader>w6 6<c-w><c-w>
nnoremap <leader>ws <c-w><c-w>
nnoremap <leader>wH <c-w>R
nnoremap <leader>wL <c-w>r
nnoremap <silent><leader>wd :close<cr>

" jump stack
nnoremap <leader>em :NavMark<CR>
nnoremap <leader>eb :NavBack<CR>
nnoremap <leader>ef :NavForward<CR>

" buffers
nnoremap <silent><leader>bd :bd<cr>

" languages
function! HandleDefinition(resp) abort
    if len(a:resp['result']) == 0
        return
    endif
    let l:loc = a:resp['result'][0]
    execute 'edit' . ' ' . fnameescape(l:loc["uri"][7:])
    let l:start = l:loc['range']['start']
    call cursor(l:start['line']+1, l:start['character']+1)
    NavMark
endfunction
nnoremap <silent><leader>ld :NavMark<CR>:call LanguageClient#textDocument_definition({}, "HandleDefinition")<CR>
nnoremap <silent><leader>lr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent><leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent><leader>lc :call LanguageClient_contextMenu()<CR>
nnoremap <silent><leader>ls :LanguageClientStart<CR>

" leaderf
noremap <silent><leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <silent><leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <silent><leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent><leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

" comment
imap <C-c> <plug>NERDCommenterInsert

" vim
nnoremap <silent><leader>vq :qall<cr>
nnoremap <silent><leader>vm :messages<cr>
nnoremap <leader>vh :help<space>
