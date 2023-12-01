" my simple neovim config
" mdhs <justfly.py@gmail.com>
" enjoy!
"
let mapleader=','

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'  " builtin language server
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-lualine/lualine.nvim'
Plug 'steelsojka/pears.nvim'  " brackets auto pair
Plug 'nvim-telescope/telescope.nvim'  " fuzzy finder
Plug 'nvim-lua/plenary.nvim'  " depended by telescope
Plug 'akinsho/toggleterm.nvim'  " better terminal
Plug 'famiu/bufdelete.nvim' " better buffer deletion
Plug 'folke/trouble.nvim'
Plug 'f-person/git-blame.nvim'
Plug 'imjustfly/rasmus.nvim'
call plug#end()

" vim settings
set mouse=
set termguicolors
set nowrap
" set spell spl=en,cjk
set signcolumn=number  " use number column to show sign
set relativenumber number
set fillchars+=vert:\|  " delimiter
set list listchars=tab:\ \ ,trail:●
set noshowmode  " no need, we already have lightline
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=4 tabstop=4
set foldmethod=indent foldnestmax=5 foldlevel=5
set completeopt=menuone
au FileType go setlocal noexpandtab

let g:rasmus_transparent = 1
let g:rasmus_bold_functions = 1
let g:rasmus_bold_keywords = 1
colorscheme rasmus
" colorscheme solarized-flat
luafile ~/.config/nvim/conf.lua

" key bindings
nnoremap <silent><leader>f :lua vim.lsp.buf.hover()<cr>
nnoremap <silent><leader>d <cmd>TroubleToggle lsp_definitions<cr>
nnoremap <silent><leader>s <cmd>Telescope lsp_implementations<cr>
nnoremap <silent><leader>r <cmd>TroubleToggle lsp_references<cr>
nnoremap <silent><leader>t <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <silent><leader>a :lua vim.lsp.buf.format()<cr>
nnoremap <silent><leader>b <cmd>GitBlameToggle<cr>
nnoremap <silent><C-p> <cmd>Telescope git_files<cr>
nnoremap <silent><C-j> <cmd>Telescope buffers<cr>
nnoremap <silent><C-y> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent><C-g> <cmd>Telescope live_grep<cr>
nnoremap <silent><C-k> <cmd>Telescope treesitter<cr>
nnoremap <silent><C-h> <cmd>bp<cr>
nnoremap <silent><C-l> <cmd>bn<cr>
nnoremap <silent><C-x> <cmd>Bdelete<cr>
xnoremap gf <cmd>Telescope grep_string<cr>
