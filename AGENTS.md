# AGENTS.md

## 1. Project Overview

This repository is a compact Neovim configuration rooted at `init.vim`, with most plugin and language tooling setup delegated to `conf.lua`.

- **Bootstrap layer:** `init.vim` declares plugins with `vim-plug`, applies editor defaults, and defines keymaps.
- **Plugin/runtime layer:** `conf.lua` configures the active Lua-based plugins and LSP clients.
- **Support scripts:** `autoload/ssh_clipboard.vim` and `bin/clipboard-provider` provide an optional clipboard integration path for SSH/tmux/local environments.
- **Theme/data:** `colors/256_noir.vim` provides the colorscheme, and `spell/` stores local spell additions.

The configuration is intentionally flat: there is no multi-module Lua tree for this repo itself. Most behavior is centralized in two files:

- `init.vim` — startup entrypoint, plugin registration, core Vim options, keymaps.
- `conf.lua` — LSP, Treesitter, completion, statusline, Telescope, terminal, and Git blame configuration.

### Main runtime components

- **Language tooling:** `nvim-lspconfig` is configured for `clangd`, `gopls`, `pylsp`, and `rust_analyzer`.
- **Syntax/structure:** `nvim-treesitter` is enabled for `cpp`, `go`, and `python`.
- **Completion:** `nvim-cmp` uses LSP and buffer sources, with manual completion behavior.
- **Navigation/UI:** `telescope.nvim`, `lualine.nvim`, `toggleterm.nvim`, `bufdelete.nvim`, `git-blame.nvim`, and `pears.nvim` are enabled.

### Architecture notes for future changes

- Add new plugin declarations in `init.vim` first, then place their Lua setup in `conf.lua` if needed.
- Keep cross-cutting editor defaults in `init.vim`; keep plugin-specific logic in `conf.lua`.
- Avoid treating `plugged/` as a source directory for this repo. It is ignored by `.gitignore` and is plugin installation state, not project-owned architecture.

## 2. Build & Commands

This repo does not define a project-level build system, deployment pipeline, or test runner.

### Bootstrap and plugin lifecycle

- Install the config by cloning to `~/.config/nvim`.
- Install plugins from inside Vim/Neovim with `:PlugInstall`.
- `nvim-treesitter` is declared with `{'do': ':TSUpdate'}`, so parser updates are part of plugin install/update flow.

### Useful repo-native commands

- `:PlugInstall` — install plugins declared in `init.vim`.
- `:PlugUpdate` — update installed plugins (provided by bundled `autoload/plug.vim`).
- `:PlugClean` — remove plugins no longer declared.
- `:PlugStatus` / `:PlugDiff` — inspect plugin state and changes.

### Runtime usage signals already encoded in the config

- `<leader>a` triggers `vim.lsp.buf.format()`.
- `<C-p>`, `<C-g>`, `<C-j>`, `<C-k>` and related mappings are the main Telescope entrypoints.
- `<c-\\>` opens the floating terminal from `toggleterm.nvim`.

### Not present in this repo

- No `Makefile`
- No `package.json`
- No project-level formatter config such as `stylua.toml`
- No project-level deployment command

## 3. Code Style

Only include style rules that are explicit in this repo:

- **Languages by role:** Vimscript lives in `init.vim` and `autoload/`; Lua plugin setup lives in `conf.lua`.
- **Indentation default:** `init.vim` sets `expandtab`, `smarttab`, `shiftwidth=4`, and `tabstop=4`.
- **Go exception:** `FileType go` uses `noexpandtab`.
- **Search behavior:** `ignorecase` with `smartcase` is the default search mode.
- **Sectioning style:** `conf.lua` groups setup by feature/plugin using short comment headers such as `-- lsp`, `-- treesitter`, and `-- cmp`.
- **Completion behavior:** `nvim-cmp` has `autocomplete = false`, so completion is intentionally not fully automatic.

### Change conventions inferred from the current layout

- Prefer small, centralized edits over creating new config modules unless the current flat layout becomes unmanageable.
- Preserve the split between editor-global settings (`init.vim`) and plugin-specific Lua setup (`conf.lua`).
- When touching Python formatting behavior, note that `pylsp` explicitly disables `yapf`.

## 4. Testing

This repository does **not** define a top-level automated test framework or a repo-owned test command.

- There is no project test runner in the repository root.
- Validation is primarily runtime validation of the Neovim config itself.
- The only explicit install/update action in the repo is plugin management through `vim-plug` and Treesitter parser updates.

### What to verify after changes

- Neovim can start and load `init.vim` plus `conf.lua` without configuration errors.
- Any changed plugin setup still matches a plugin declared in `init.vim`.
- If LSP or completion behavior is edited, verify the affected language server/plugin is still configured consistently in `conf.lua`.

Do not treat tests inside `plugged/` as tests for this repository; those belong to upstream plugins.

## 5. Security

Security-relevant behavior in this repo is concentrated in the clipboard helper.

### Clipboard integration

- `autoload/ssh_clipboard.vim` defines a custom `g:clipboard` provider only when `clipboard-provider` is executable.
- `bin/clipboard-provider` shells out to external programs such as `tmux`, `pbcopy`/`pbpaste`, `xclip`, and OSC52 terminal escape handling.
- The script falls back to local storage at `$HOME/.clipboard-provider.out`.

### Practical implications

- Clipboard content may traverse tmux, terminal OSC52, or local file storage depending on available providers.
- Changes to clipboard behavior should be reviewed carefully because they affect data movement outside Neovim itself.
- If enabling or modifying the SSH clipboard path, make sure the executable lookup (`executable('clipboard-provider')`) and PATH assumptions still hold.

### Repo-local protection signals

`.gitignore` excludes transient or machine-local state such as:

- `plugged/`
- `.DS_Store`
- `*.swp`
- `cache/`
- `.netrwhist`
- `*.spl`

## 6. Configuration

### Environment setup

- Install location is expected to be `~/.config/nvim`.
- The primary startup file is `init.vim`, which loads `conf.lua` via `luafile ~/.config/nvim/conf.lua`.
- The configured colorscheme is `256_noir`.

### External tools expected by current config

- `git` is required by `vim-plug` operations.
- The configured LSP servers are `clangd`, `gopls`, `pylsp`, and `rust_analyzer`.
- Optional clipboard helpers include `tmux`, `pbcopy`/`pbpaste`, and `xclip`.

### Managed feature set

- Treesitter parsers are ensured for `cpp`, `go`, and `python`.
- LSP semantic tokens are disabled in `on_attach` for configured servers.
- `toggleterm.nvim` is configured to open as a floating terminal sized from the current Neovim UI.
- `gitblame` is present but starts disabled.

### Agent-specific repo notes

- No existing `AGENT.md` or `AGENTS.md` was present before this file was added.
- No Cursor rules were found under `.cursor/rules/`.
- No Copilot instructions were found at `.github/copilot-instructions.md`.
- No Trae rules were found under `.trae/rules/`.

If you extend this repo, update this file only when the architecture, commands, or explicit conventions actually change.
