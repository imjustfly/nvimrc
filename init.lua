-- init.lua (Neovim 0.12+)

-- =========================
-- bootstrap
-- =========================

vim.g.mapleader = ','

vim.pack.del_non_active = function()
  local pkgs = vim.iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable()
  vim.pack.del(pkgs)
end

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

  gh('nvim-treesitter/nvim-treesitter'),
  gh('AlexvZyl/nordic.nvim'),

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
vim.o.completeopt = 'menu,menuone,preinsert,nearest'
vim.o.complete = '.,o,w,b,u,t'
vim.o.pummaxwidth = 40
vim.o.laststatus = 3
vim.o.statusline = table.concat({
  '> %f',                                -- 文件名
  '%m%r',                                -- 修改/只读
  '%{&busy ? " ◐" : " OK"}',             -- busy 状态
  ' %{%v:lua.vim.diagnostic.status()%}', -- 诊断
  '%=',                                  -- 右对齐
  '%{%v:lua.vim.ui.progress_status()%}', -- 进度
  ' %y',                                 -- 文件类型
  ' %l:%c',                              -- 行:列
  ' %P ',                                -- 百分比
})

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
vim.keymap.set('i', '<Tab>', function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return '<Tab>'
  end

  return '<C-n>'
end, { expr = true, silent = true })

-- =========================
-- LSP (built-in)
-- =========================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user.lsp.attach', { clear = true }),
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
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
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
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
-- treesitter
-- =========================
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp', 'c', 'lua', 'python', 'thrift', 'proto', 'go' },
  callback = function() vim.treesitter.start() end,
})

-- =========================
-- plugin setups
-- =========================

do
  local pears = safe_require('pears')
  if pears then
    pears.setup()
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

require("nordic").setup({
  transparent = { bg = true}
})

vim.cmd.colorscheme("nordic")
