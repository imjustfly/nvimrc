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
let mapleader=','

" leaderf
let g:Lf_ShortcutF = "<C-p>"
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
            \ 'go' : ['gopls'],
            \ 'python' : ['pyls'],
            \ 'cpp' : ['clangd'],
    \ }
let g:LanguageClient_loggingFile = '/tmp/languageclient.log'
let g:LanguageClient_hoverPreview = 'Auto'
let g:LanguageClient_useFloatingHover = 0
let g:LanguageClient_useVirtualText = "No"
let g:LanguageClient_showCompletionDocs = 0

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
au BufNewFile,BufRead go.mod if getline(1) =~ '^module.*' | set filetype=gomod |  endif
au FileType python setlocal et sta sw=4 sts=4
au FileType python setlocal foldmethod=indent
au FileType markdown set nowrap
au FileType go setlocal noexpandtab
au FileType vue set shiftwidth=2 tabstop=2
au FileType cpp set shiftwidth=2 tabstop=2
au FileType javascript set shiftwidth=2 tabstop=2
au FileType qf nnoremap <buffer> <Esc> :q<Enter>
au QuickFixCmdPost *grep* cwindow

" relative line number
set number
function! ToggleRelativeNumber() abort
    let l:on = &relativenumber
    if l:on
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
nnoremap <silent><C-l> :call ToggleRelativeNumber()<cr>

" global key bindings
"
" jump stack
map <silent><C-e> <ESC>
nnoremap <silent><C-e>m :NavMark<CR>
nnoremap <silent><C-e>b :NavBack<CR>
nnoremap <silent><C-e>f :NavForward<CR>

" buffers
nnoremap <silent><leader>bd :bd<cr>

" languages
function! LCNDefinition() abort
    NavMark
    call LanguageClient_runSync("LanguageClient#textDocument_definition", {'handle': v:true})
    NavMark
endfunction
function! LCNHover() abort
    if g:LanguageClient_useFloatingHover
        call LanguageClient#textDocument_hover()
        return
    endif
    call LanguageClient_runSync("LanguageClient#textDocument_hover", {'handle': v:true})
    wincmd p
    if getwinvar(win_id2win(win_getid()), "&pvw")
        setlocal wrap
        nnoremap <silent><buffer><ESC> :q<CR>
    endif
endfunction
nnoremap <silent><leader>d :call LCNDefinition()<CR>
nnoremap <silent><leader>r :call LanguageClient#textDocument_references()<CR>
nnoremap <silent><leader>f :call LCNHover()<CR>
nnoremap <silent><leader>s :call LanguageClient#textDocument_implementation()<CR>

" leaderf
noremap <silent><C-j> :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <silent><C-k> :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent><C-l> :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

" comment
imap <C-c> <plug>NERDCommenterInsert
