" my simple neovim config
" mdhs <justfly.py@gmail.com>
" enjoy!

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'ervandew/supertab'  " use tab to select candidate words
Plug 'Shougo/echodoc.vim'  " echo func doc in status line
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'  " brackets auto close
Plug 'scrooloose/nerdcommenter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'imjustfly/vim-navigator'
Plug 'morhetz/gruvbox'
call plug#end()

let mapleader=','

" plugin settings
let g:Lf_ShortcutF = "<C-p>"
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:LanguageClient_serverCommands = {'go' : ['gopls'], 'cpp' : ['clangd']}
let g:LanguageClient_loggingFile = '/tmp/lcn.log'
let g:LanguageClient_useVirtualText = "No"
let g:LanguageClient_showCompletionDocs = 0
let g:echodoc_enable_at_startup = 1
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:lightline = {'colorscheme': 'gruvbox'}
let g:NERDSpaceDelims = 1
let g:gruvbox_contrast_dark = 'hard'
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]

" vim settings
syntax on
syntax enable
filetype plugin indent on
colorscheme gruvbox
set termguicolors background=dark
set signcolumn=number  " use number comlumn to show sign
set relativenumber number
set fillchars+=vert:\|
set list listchars=tab:▶‧,space:‧,eol:↵,nbsp:×
set noshowmode  " no need, we already have lightline
set hidden  " allow hidden buffer being unsaved
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=4 tabstop=4
set foldmethod=syntax foldnestmax=5 foldlevel=5
set completeopt=noinsert,menuone,noselect
au FileType python setlocal foldmethod=indent
au FileType go setlocal noexpandtab
au FileType cpp setlocal shiftwidth=2 tabstop=2
au FileType javascript setlocal shiftwidth=2 tabstop=2

" key bindings
map <silent><C-e> <ESC>
nnoremap <silent><C-e>m :NavMark<CR>
nnoremap <silent><C-e>j :NavBack<CR>
nnoremap <silent><C-e>k :NavForward<CR>
function! LCNDefinition() abort
    NavMark
    call LanguageClient_runSync("LanguageClient#textDocument_definition", {'handle': v:true})
    NavMark
endfunction
nnoremap <silent><leader>d :call LCNDefinition()<CR>
nnoremap <silent><leader>r :call LanguageClient#textDocument_references()<CR>
nnoremap <silent><leader>f :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent><leader>s :call LanguageClient#textDocument_implementation()<CR>
noremap <silent><C-j> :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <silent><C-k> :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent><C-l> :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>
au FileType qf nnoremap <buffer> <Esc> :q<Enter>
