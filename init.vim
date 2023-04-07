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
Plug 'nanotech/jellybeans.vim'
call plug#end()

" vim settings
set termguicolors
set signcolumn=number  " use number comlumn to show sign
set relativenumber number
set fillchars+=vert:\|  " delimiter
set list listchars+=trail:◦
set noshowmode  " no need, we already have lightline
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=2 tabstop=2
set foldnestmax=5 foldlevel=5
set completeopt=menuone
au FileType go setlocal noexpandtab
au FileType cpp,python setlocal shiftwidth=4 tabstop=4

" plugin and colors
let g:jellybeans_overrides = { 'background': { 'guibg': '000000' } }
colorscheme jellybeans
luafile ~/.config/nvim/conf.lua
call ssh_clipboard#Enable()

" key bindings
nnoremap <silent><leader>f :lua vim.lsp.buf.hover()<CR>
nnoremap <silent><leader>d <cmd>Telescope lsp_definitions<CR>
nnoremap <silent><leader>s <cmd>Telescope lsp_implementations<CR>
nnoremap <silent><leader>r <cmd>Telescope lsp_references<CR>
nnoremap <silent><leader>t <cmd>Telescope diagnostics bufnr=0<CR>
nnoremap <silent><leader>a :lua vim.lsp.buf.formatting()<CR>
nnoremap <silent><C-p> <cmd>Telescope git_files<cr>
nnoremap <silent><C-l> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent><C-g> <cmd>Telescope live_grep<cr>
nnoremap <silent><C-k> <cmd>Telescope treesitter<cr>
nnoremap <silent><C-j> <cmd>Telescope buffers<cr>
xnoremap gf <cmd>Telescope grep_string<cr>
