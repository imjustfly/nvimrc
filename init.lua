-- new_init.lua (Neovim 0.12+)

-- =========================
-- bootstrap
-- =========================

vim.g.mapleader = ','

local function safe_require(mod)
  local ok, m = pcall(require, mod)
  if ok then
    return m
  end
  vim.schedule(function()
    vim.notify(('require(%q) failed: %s'):format(mod, m), vim.log.levels.WARN)
  end)
  return nil
end

-- Ensure stdpath('data')/site is in 'packpath' (needed for --clean in some cases).
do
  local data_site = vim.fn.stdpath('data') .. '/site'
  local pp = vim.opt.packpath:get()
  local found = false
  for _, p in ipairs(pp) do
    if p == data_site then
      found = true
      break
    end
  end
  if not found then
    vim.opt.packpath:append(data_site)
  end
end

-- =========================
-- vim.pack (plugins)
-- =========================

local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-telescope/telescope.nvim'),

  { src = gh('nvim-treesitter/nvim-treesitter'), name = 'nvim-treesitter' },

  gh('hrsh7th/nvim-cmp'),
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('hrsh7th/cmp-buffer'),

  gh('nvim-lualine/lualine.nvim'),
  gh('steelsojka/pears.nvim'),
  gh('akinsho/toggleterm.nvim'),
  gh('famiu/bufdelete.nvim'),
  gh('f-person/git-blame.nvim'),
})

-- =========================
-- options
-- =========================

vim.o.mouse = ''
vim.wo.wrap = false
vim.wo.signcolumn = 'number'
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.fillchars:append({ vert = '|' })
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '●' }
vim.o.showmode = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 5
vim.o.foldlevel = 5
vim.o.completeopt = 'menuone'

-- =========================
-- clipboard provider (ssh_clipboard)
-- =========================

do
  local bin_dir = vim.fn.expand('~/.config/nvim/bin')
  local path = vim.env.PATH or ''
  if not path:find(bin_dir, 1, true) then
    vim.env.PATH = path .. ':' .. bin_dir
  end
  pcall(function()
    vim.fn['ssh_clipboard#Enable']()
  end)
end

-- =========================
-- autocmds
-- =========================

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user.filetype', { clear = true }),
  pattern = 'go',
  callback = function(args)
    vim.bo[args.buf].expandtab = false
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('user.terminal', { clear = true }),
  pattern = 'term://*toggleterm#*',
  callback = function(args)
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = args.buf })
  end,
})

-- =========================
-- keymaps
-- =========================

vim.keymap.set('n', '<leader>f', vim.lsp.buf.hover, { silent = true })
vim.keymap.set('n', '<leader>d', '<cmd>Telescope lsp_definitions<cr>', { silent = true })
vim.keymap.set('n', '<leader>s', '<cmd>Telescope lsp_implementations<cr>', { silent = true })
vim.keymap.set('n', '<leader>r', '<cmd>Telescope lsp_references<cr>', { silent = true })
vim.keymap.set('n', '<leader>t', '<cmd>Telescope diagnostics bufnr=0<cr>', { silent = true })
vim.keymap.set('n', '<leader>a', function()
  vim.lsp.buf.format()
end, { silent = true })

vim.keymap.set('n', '<leader>b', '<cmd>GitBlameToggle<cr>', { silent = true })

vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<cr>', { silent = true })
vim.keymap.set('n', '<C-j>', '<cmd>Telescope buffers<cr>', { silent = true })
vim.keymap.set('n', '<C-y>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { silent = true })
vim.keymap.set('n', '<C-g>', '<cmd>Telescope live_grep<cr>', { silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>Telescope treesitter<cr>', { silent = true })

vim.keymap.set('n', '<C-h>', '<cmd>bp<cr>', { silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>bn<cr>', { silent = true })
vim.keymap.set('n', '<C-x>', '<cmd>Bdelete<cr>', { silent = true })

vim.keymap.set('x', 'gf', '<cmd>Telescope grep_string<cr>', { silent = true })

-- =========================
-- LSP (built-in)
-- =========================

local capabilities = vim.lsp.protocol.make_client_capabilities()
do
  local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user.lsp.attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.lsp.config.clangd = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'cc' },
  root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
}

vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
}

vim.lsp.config.pylsp = {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt' },
  settings = {
    pylsp = {
      plugins = {
        yapf = { enabled = false },
      },
    },
  },
}

vim.lsp.config.rust_analyzer = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
}

vim.lsp.enable({ 'clangd', 'gopls', 'pylsp', 'rust_analyzer' })

-- =========================
-- plugin setups
-- =========================

do
  -- NOTE: recent nvim-treesitter versions expose `require('nvim-treesitter').setup()`.
  -- Older configs used `nvim-treesitter.configs`, but that module is not always present.
  local ts = safe_require('nvim-treesitter')
  if ts then
    ts.setup({
      ensure_installed = { 'cpp', 'go', 'python' },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'python' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
          scope_incremental = '<TAB>',
        },
      },
      indent = {
        enable = true,
        disable = { 'python' },
      },
    })
  end
end

do
  local lualine = safe_require('lualine')
  if lualine then
    lualine.setup({
      sections = {
        lualine_b = { 'branch' },
        lualine_c = { { 'buffers', buffers_color = { active = 'white' } } },
        lualine_x = { 'diff', 'diagnostics', 'filetype' },
      },
      options = { section_separators = '', component_separators = '', globalstatus = true },
    })
  end
end

do
  local pears = safe_require('pears')
  if pears then
    pears.setup()
  end
end

do
  local cmp = safe_require('cmp')
  if cmp then
    local has_words_before = function()
      local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then
        return false
      end
      local l = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      return l:sub(col, col):match('%s') == nil
    end

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      }),
      completion = {
        autocomplete = false,
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
    })
  end
end

do
  local telescope = safe_require('telescope')
  if telescope then
    local actions = safe_require('telescope.actions')
    telescope.setup({
      defaults = {
        mappings = actions and {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<esc>'] = actions.close,
          },
        } or nil,
        layout_strategy = 'horizontal',
      },
    })
  end
end

do
  local toggleterm = safe_require('toggleterm')
  if toggleterm then
    local function term_width(term)
      return math.min(math.floor(vim.o.columns * 0.8), 180)
    end

    local function term_height(term)
      return math.floor(vim.o.lines * 0.8)
    end

    toggleterm.setup({
      open_mapping = [[<c-\>]],
      direction = 'float',
      float_opts = {
        width = term_width,
        height = term_height,
      },
    })
  end
end

do
  local gitblame = safe_require('gitblame')
  if gitblame then
    gitblame.setup({ enabled = false })
  end
end

-- =========================
-- colorscheme
-- =========================

pcall(vim.cmd, 'colorscheme 256_noir')
