" my simple neovim config
" mdhs <justfly.py@gmail.com>
" enjoy!

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'roxma/nvim-yarp'  "needed by ncm2
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ervandew/supertab'
Plug 'Shougo/echodoc.vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
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
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:lightline = {'colorscheme': 'gruvbox'}
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_sign_modified_removed = '>'
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:gruvbox_contrast_dark = 'hard'
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect  " :help Ncm2PopupOpen

" vim settings
syntax on
syntax enable
colorscheme gruvbox
set termguicolors
set background=dark
set autoindent
set regexpengine=1
set backspace=2
set noshowmode
set ignorecase
set fileencodings=utf-8
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
set listchars=tab:▶‧,nbsp:%,space:‧,eol:↵,nbsp:×
set relativenumber number

filetype plugin indent on
au FileType python setlocal et sta sw=4 sts=4 foldmethod=indent
au FileType go setlocal noexpandtab
au FileType cpp set shiftwidth=2 tabstop=2
au FileType javascript set shiftwidth=2 tabstop=2
au FileType qf nnoremap <buffer> <Esc> :q<Enter>

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
