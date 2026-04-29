--[[
  This file started its life as a copy of [kickstart](https://github.com/nvim-lua/kickstart.nvim).
  but has since evolved significantly.
  I recommend starting there.

  TODO:
    * prefer standard keymaps
    * add keygroups where appropriate
    * gr -> lsp actions
    * hook :Update into imbue?
    * [undotree?](https://github.com/mbbill/undotree)
    * show session name in statusline https://stackoverflow.com/questions/11374047/how-to-add-the-current-session-file-name-in-the-status-line-in-vim
    * completion
        * mini.snippets
        * remove vim snippets, they are almost never what I want.
        * alternatively, change the keybind to accept a change
        * alternatively, replace with ollama complete (probably way too slow)
        * [cmp-ai](https://github.com/tzachar/cmp-ai)
        * [llm](https://github.com/huggingface/llm.nvim)
        * [windsurf](https://github.com/Exafunction/windsurf.nvim)
    * nvim slop
        * [avante](https://github.com/yetone/avante.nvim)
        * ollama
        * [avante config](https://github.com/yetone/avante.nvim/pull/1543)
        * [mcphub](https://github.com/ravitemer/mcphub.nvim)
            * [avante+mcphub](https://ravitemer.github.io/mcphub.nvim/extensions/avante.html)
    * standardize nvim-web-dev-icons vs mini.icons vs nerdfonts icons
    * nvim set noexpandtab for tsv
    * [image.nvim](https://github.com/3rd/image.nvim)
        * unbearably slow. need an alternative
    * nvim colorscheme
        * lush.nvim interactive colorscheme
        * mini.colors 
        * mini.hues (:colorscheme randomhue)
        * mini.base16
        * nvim use [colorscheme template](https://github.com/datsfilipe/nvim-colorscheme-template)
        * [original spacedust](https://github.com/hallski/spacedust-theme)
        * remember colorscheme in mini.sessions?
    * gdb + nvim-dap, align keybinds with nvim-lsp keys
    * integrate gg with nvim sessions?
    * database vim tpope/dadbod-vim
    * see TODO.md
--]]

-- NOTE leader must be set before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.number = true                                           -- show line number
vim.opt.mouse = "a"                                             -- Enable mouse mode
vim.opt.showmode = false                                        -- don't show mode on message line.
vim.schedule(function()                                         --  use system clipboard unless on tty
    vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
end)

vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.timeoutlen = 300   -- Decrease mapped sequence wait time
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true          -- show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- preview substitutions live
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fixendofline = false -- don't mess with line endings, especially when dealing with legacy windows projects
vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
vim.opt.spelllang = { "en" }
vim.opt.termguicolors = true  -- True color support
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wrap = true           -- wrap text that is too long
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "disable search highlighting" })
-- let 0 toggle between the start and end of line
vim.keymap.set(
    { "n", "v" },
    "0",
    '<Cmd>if col(\'.\') - 1<bar>exe "normal! 0"<bar>else<bar> exe "normal! $"<bar>endif<CR>'
)
vim.keymap.set("n", "q:", ":q", { desc = "don't open command split, ya dumbass" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- handle paste events in insert and command modes
vim.keymap.set({ "i", "c" }, "<c-v>", "<c-r>+")

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- [[ windows / panes ]]
vim.keymap.set("n", "<A-s>", "<cmd>sp<cr>", { desc = "Open a split", remap = true })
vim.keymap.set("n", "<A-v>", "<cmd>vs<cr>", { desc = "Open a vertical split", remap = true })

-- Move to window using the <Alt> hjkl keys
vim.keymap.set({ "n", "t" }, "<A-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set({ "n", "t" }, "<A-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set({ "n", "t" }, "<A-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set({ "n", "t" }, "<A-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> hjkl keys
vim.keymap.set("n", "<C-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- [[ tabs ]]
vim.keymap.set("n", "<A-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<A-u", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<A-i", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<A-o", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<A-p", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<A-W", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- [[ buffers ]]
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<A-e>", "<cmd>Pick files<cr>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<A-space>", "<cmd>Pick buffers<cr>", { desc = "Fuzzy find buffers" })

-- [[ find ]]
vim.keymap.set("n", "<A-f>", "<cmd>Pick grep_live<cr>", { desc = "Fuzzy grep text" })

-- hex
-- see ~/.config/nvim/syntax/hex.vim
-- TODO save and restore cursor position. this is non-trivial
function ToggleHex()
    if vim.b.hexed then
        vim.cmd("%!xxd -r")
        vim.cmd("filetype detect")
    else
        vim.cmd("%!xxd")
        vim.cmd("set syntax=hex")
    end
    vim.b.hexed = not vim.b.hexed
end

vim.keymap.set("n", "<leader>h", ToggleHex, { desc = "view hex" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- `n` always searches forward and `N` always backwards
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- select the last pasted or changed text
-- see :help gv
vim.keymap.set("n", "gp", "`[v`]")

-- TODO do these work?
vim.keymap.set("n", "]e", function()
    vim.diagnostic.jump({ count = 1, severity = 1 })
end, { desc = "Next Error" })
vim.keymap.set("n", "[e", function()
    vim.diagnostic.jump({ count = -1, severity = 1 })
end, { desc = "Prev Error" })
vim.keymap.set("n", "]w", function()
    vim.diagnostic.jump({ count = 1, severity = 2 })
end, { desc = "Next Warning" })
vim.keymap.set("n", "[w", function()
    vim.diagnostic.jump({ count = -1, severity = 2 })
end, { desc = "Prev Warning" })

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

vim.api.nvim_create_user_command(
    "Update",
    function()
        vim.pack.update()
    end,
    { desc = "update plugins" }
)
vim.pack.add({
    "https://github.com/folke/which-key.nvim",  -- show hints for leader keys
    "https://github.com/nvim-lua/plenary.nvim", -- dep
})
local function keygroup(leader, desc)
    require("which-key").add({ leader, desc = desc })
end

-- gitsigns / neogit
vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/nvim-lua/plenary.nvim",  -- dep
    "https://github.com/sindrets/diffview.nvim", -- dep
})
keygroup("<leader>g", "Git")
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "start git commit" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "show blame line" })
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "show full blame" })

vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
--vim.cmd.colorscheme("tokyonight-night")
vim.pack.add({"https://github.com/toombs-caeman/spacedust.nvim"})
vim.cmd.colorscheme("spacedust")

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
require("mini.misc").setup_restore_cursor()
require("mini.misc").setup_termbg_sync()
require("mini.pick").setup({
    mappings = {
        move_down = "<a-j>",
        move_up = "<a-k>",
        choose_in_split = "<a-s>",
        choose_in_tabpage = "<a-t>",
        choose_in_vsplit = "<a-v>",
    },
})
local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup({
    n_lines = 500,
    custom_textobjects = {
        -- TODO this is not working after removing treesitter
        f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        d = gen_ai_spec.diagnostic(),
        i = gen_ai_spec.indent(),
        -- TODO conflicts with last text obj
        l = gen_ai_spec.line(),
    },
})
-- Add/delete/replace surroundings (brackets, quotes, etc.)
require("mini.surround").setup()
-- session management
require("mini.sessions").setup({ file = "" })

require("mini.pick").registry.session = function() require("mini.sessions").select() end
require("mini.pick").registry.session_delete = function() require("mini.sessions").select('delete') end
require("mini.pick").registry.colors = require("mini.extra").pickers.colorschemes
vim.api.nvim_create_user_command(
    'Session',
    function(cmd_args)
        require("mini.sessions").write(cmd_args.args)
    end,
    { desc = "create a new session", nargs = 1 }
)

require("mini.comment").setup()
require("mini.pairs").setup()
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
    highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

vim.keymap.set("n", "-", "<cmd>lua require('mini.files').open()<cr>", { desc = "Edit Directories" })
require("mini.jump").setup({
    delay = { highlight = 1000000000, idle_stop = 0 },
})
require("mini.starter").setup({ header = "", footer = "" })
require("mini.splitjoin").setup({ mappings = { toggle = "sj" } })
require("mini.statusline").setup({ use_icons = true })

vim.pack.add({
    "https://github.com/benomahony/uv.nvim", -- uv python package manager
})
keygroup("<leader>x", "uv: python package manager")
require("uv").setup()

vim.pack.add({
    "https://github.com/denialofsandwich/sudo.nvim", -- sudo edit
    "https://github.com/MunifTanjim/nui.nvim",       -- dep
})
---@diagnostic disable-next-line: missing-parameter
require("sudo").setup()

vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap", -- debugger
})
vim.keymap.set("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
    require("dap").continue()
end, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", function()
    require("dap").run_to_cursor()
end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dt", function()
    require("dap").terminate()
end, { desc = "Terminate" })

-- TODO completion, don't like "hrsh7th/nvim-cmp",
--  try blink.cmp? https://dotfyle.com/plugins/saghen/blink.cmp
-- ["<A-Tab>"] = cmp.mapping.confirm({ select = true }),
-- ["<Tab>"] = cmp.mapping.select_next_item(),
-- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
-- ["<C-Space>"] = cmp.mapping.complete({}),

-- automatically set up common LSP toolchains with default options
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/stevearc/conform.nvim",
})
keygroup("gr", "LSP") -- see :help lsp-defaults
require("mason").setup()
require("mason-lspconfig").setup()
vim.keymap.set("n", "grq", vim.diagnostic.setloclist, { desc = "quickfix list" })
vim.keymap.set("n", "grf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "format buffer" })
