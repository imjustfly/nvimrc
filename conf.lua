-- configurations for lua plugins
--

-- lsp
local servers = {"gopls", "clangd", "pylsp"}
local nvim_lsp = require("lspconfig")
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({})
end

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {"cpp", "go", "python"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>"
        }
    }
})

-- lualine
require("lualine").setup({
    sections = {
        lualine_b = {"branch"},
        lualine_c = {{"buffers", buffers_color = {active = 'white'}}},
        lualine_x = {"diff", "diagnostics", "filetype"},
    },
    options = {section_separators = "", component_separators = "", globalstatus = true},
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
        layout_config = {
            vertical = {width = 0.5, height = 0.5}
        },
        layout_strategy = "vertical",
    },
})

-- toggleterm
require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = 'float'
})
function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- trouble
require("trouble").setup({
    height = 15,
    icons = false,
})
