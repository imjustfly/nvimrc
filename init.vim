" my simple neovim config
" mdhs <justfly.py@gmail.com>
" enjoy!

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'neovim/nvim-lspconfig'
Plug 'ervandew/supertab'  " use tab to select candidate words
Plug 'Shougo/echodoc.vim'  " echo func doc in status line
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'  " brackets auto close
Plug 'bronson/vim-trailing-whitespace'
call plug#end()

let mapleader=','

" plugin settings
let g:Lf_ShortcutF = "<C-p>"
let g:Lf_UseCache = 0
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:echodoc_enable_at_startup = 1
let g:SuperTabDefaultCompletionType = '<c-n>'
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
lua << EOF
local servers = { 'gopls', 'clangd', 'pylsp' }
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_set_var('SuperTabDefaultCompletionType','<c-x><c-o>')
end
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end
EOF

" vim settings
syntax on
syntax enable
filetype plugin indent on
set signcolumn=number  " use number comlumn to show sign
set relativenumber number
set fillchars+=vert:\|  " delimiter
set noshowmode  " no need, we already have lightline
set hidden  " allow hidden buffer being unsaved
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=4 tabstop=4
set foldmethod=syntax foldnestmax=5 foldlevel=5
set completeopt=noinsert,menuone,noselect  "complete like IDE
au FileType python setlocal foldmethod=indent
au FileType go setlocal noexpandtab shiftwidth=2 tabstop=2
au FileType cpp setlocal shiftwidth=2 tabstop=2
au FileType javascript setlocal shiftwidth=2 tabstop=2

" key bindings
nnoremap <silent><leader><ESC> :cclose<CR>
nnoremap <silent><leader>f :lua vim.lsp.buf.hover()<CR>
nnoremap <silent><leader>r :lua vim.lsp.buf.references()<CR>
nnoremap <silent><leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <silent><leader>s :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent><leader>a :lua vim.lsp.buf.formatting()<CR>
nnoremap <silent><C-j> :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
nnoremap <silent><C-k> :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
nnoremap <silent><C-l> :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
au FileType qf wincmd J | nnoremap <buffer> <Esc> :q<Enter>
