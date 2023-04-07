-- configurations for lua plugins
--

-- lsp
local servers = { 'gopls', 'clangd', 'pylsp' }
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({})
end

-- treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {"cpp", "go", "python"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
}
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- lualine
require('lualine').setup({
  options = {section_separators = '', component_separators = '' },
  sections = {
    lualine_c = {{'filename', path = 1}},
    lualine_x = {{'buffers'}},
  }
})

-- pears
require('pears').setup()

-- cmp
local cmp = require('cmp')
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
  preselect = cmp.PreselectMode.None,
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  completion = {
    autocomplete = false
  },
  -- behave like suptertab
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

-- telescope
require('telescope').setup({
  defaults = {
    layout_strategy = 'bottom_pane',
    layout_config = {
      vertical = { width = 0.5, height = 0.5 },
    },
    mappings = {
        i = {
            ["<C-j>"] = require('telescope.actions').move_selection_next,
            ["<C-k>"] = require('telescope.actions').move_selection_previous,
            ["<esc>"] = require('telescope.actions').close,
        },
    }
  },
})
