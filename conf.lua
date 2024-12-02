-- configurations for lua plugins
--

-- lsp
local nvim_lsp = require("lspconfig")
local on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
end
nvim_lsp.clangd.setup{on_attach = on_attach, filetypes = { "c", "cpp", "cc"}}
nvim_lsp.gopls.setup{on_attach = on_attach}
nvim_lsp.pylsp.setup{on_attach = on_attach, settings = {
    pylsp = {
        plugins = {
            yapf = {enabled = false},
        }
    }
}}
nvim_lsp.rust_analyzer.setup{on_attach = on_attach}

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {"cpp", "go", "python"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "python" }
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>"
        }
    },
    indent = {
        enable = true,
        disable = {"python"}
    }
})

-- lualine
require("lualine").setup({
     options = {globalstatus = true},
})

-- pears
require("pears").setup()

-- cmp
local cmp = require("cmp")
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
    preselect = cmp.PreselectMode.None,
    sources = cmp.config.sources(
        {
            {name = "nvim_lsp"},
            {name = "buffer"}
        }
    ),
    completion = {
        autocomplete = false
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            {"i", "s"}
        ),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({select = true})
    }
})

-- telescope
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<esc>"] = require("telescope.actions").close
            }
        },
        layout_strategy = "horizontal",
    },
})

-- toggleterm
function term_width(term)
    return math.min(math.floor(vim.o.columns * 0.8), 180)
end

function term_height(term)
    local width = term_width(term)
    return math.floor(vim.o.lines * 0.8)
end
-- end

require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = 'float',
    float_opts = {
        width = term_width,
        height = term_height,
    }
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

-- git blame
require('gitblame').setup({
    enabled = false,
})
