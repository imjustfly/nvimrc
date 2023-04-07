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
Plug 'nanotech/jellybeans.vim'
Plug 'akinsho/toggleterm.nvim'  " better terminal
Plug 'lewis6991/spellsitter.nvim' " better spell check
call plug#end()

" vim settings
set termguicolors
set spell
set signcolumn=number  " use number column to show sign
set relativenumber number
set fillchars+=vert:\|  " delimiter
set list listchars=tab:>-,eol:↲,trail:◦
set noshowmode  " no need, we already have lightline
set splitbelow splitright
set ignorecase smartcase  " ignore case for searching
set expandtab smarttab shiftwidth=4 tabstop=4
set foldnestmax=5 foldlevel=5
set completeopt=menuone
au FileType go setlocal noexpandtab

" plugin and colors
let g:jellybeans_overrides = {
            \ 'background': {'guibg': '000000'},
            \ 'SpellBad': {'guibg': '222222'},
            \ 'SpellCap': {'guibg': '222222'},
            \}
colorscheme jellybeans
luafile ~/.config/nvim/conf.lua
call ssh_clipboard#Enable()

" key bindings
nnoremap <silent><leader>f :lua vim.lsp.buf.hover()<cr>
nnoremap <silent><leader>d <cmd>Telescope lsp_definitions<cr>
nnoremap <silent><leader>s <cmd>Telescope lsp_implementations<cr>
nnoremap <silent><leader>r <cmd>Telescope lsp_references<cr>
nnoremap <silent><leader>t <cmd>Telescope diagnostics bufnr=0<cr>
nnoremap <silent><leader>a :lua vim.lsp.buf.formatting()<cr>
nnoremap <silent><C-p> <cmd>Telescope git_files<cr>
nnoremap <silent><C-j> <cmd>Telescope buffers<cr>
nnoremap <silent><C-y> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent><C-g> <cmd>Telescope live_grep<cr>
nnoremap <silent><C-k> <cmd>Telescope treesitter<cr>
nnoremap <silent><C-h> <cmd>bp<cr>
nnoremap <silent><C-l> <cmd>bn<cr>
nnoremap <silent><C-x> <cmd>bd<cr>
xnoremap gf <cmd>Telescope grep_string<cr>
