" my simple neovim config
" mdhs <justfly.py@gmail.com>
" enjoy!
"
let mapleader=','

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'  " buildin language server
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-lualine/lualine.nvim'
Plug 'steelsojka/pears.nvim'  " brackets auto pair
Plug 'nvim-lua/plenary.nvim'  " depended by telesope
Plug 'nvim-telescope/telescope.nvim'  " fuzzy finder
call plug#end()

" vim settings
syntax enable
filetype plugin indent on
set signcolumn=number  " use number comlumn to show sign
set relativenumber number
set fillchars+=vert:\|  " delimiter
set noshowmode  " no need, we already have lightline
set hidden  " allow unsaved buffer to be hidden
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=4 tabstop=4
set foldmethod=syntax foldnestmax=5 foldlevel=5
set completeopt=menuone
au FileType python setlocal foldmethod=indent
au FileType go setlocal noexpandtab shiftwidth=2 tabstop=2
au FileType cpp,lua,javascript setlocal shiftwidth=2 tabstop=2

" plugin settings
luafile ~/.config/nvim/conf.lua

" key bindings
nnoremap <silent><leader><ESC> :cclose<CR>
nnoremap <silent><leader>f :lua vim.lsp.buf.hover()<CR>
nnoremap <silent><leader>r <cmd>Telescope lsp_references<CR>
nnoremap <silent><leader>d <cmd>Telescope lsp_definitions<CR>
nnoremap <silent><leader>s <cmd>Telescope lsp_implementations<CR>
nnoremap <silent><leader>t <cmd>Telescope lsp_document_diagnostics<CR>
nnoremap <silent><leader>a :lua vim.lsp.buf.formatting()<CR>
nnoremap <silent><C-p> <cmd>Telescope find_files<cr>
nnoremap <silent><C-j> <cmd>Telescope buffers<cr>
nnoremap <silent><C-l> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent><C-g> <cmd>Telescope live_grep<cr>
xnoremap gf <cmd>Telescope grep_string<cr>
