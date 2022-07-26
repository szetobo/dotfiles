-- Global options
local options = {
  clipboard = "unnamedplus",
  completeopt = { "menu", "menuone", "noselect" },
  conceallevel = 0,
  cursorline = true,
  expandtab = true,
  grepprg = "rg --vimgrep --smart-case --follow",
  hlsearch = true,
  ignorecase = true,
  list = true,
  number = true,
  scrolloff = 5,
  shiftwidth = 2,
  showmode = false,
  sidescrolloff = 5,
  signcolumn = "yes",
  smartcase = true,
  softtabstop = 2,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  timeoutlen = 1000,
  undofile = true,
  undolevels = 5000,
  updatetime = 300,
  wrap = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.matchpairs:append "<:>"
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

vim.g.tokyonight_colors = { border = "orange" }
vim.g.tokyonight_style = "strom"
vim.cmd "colorscheme tokyonight"

vim.g.NERDTreeQuitOnOpen          = 1
vim.g.webdevicons_enable_nerdtree = 1

vim.g.sexp_filetypes                   = "clojure,scheme,lisp,fennel,janet"
vim.g.sexp_enable_insert_mode_mappings = 0
vim.g.sexp_mappings = {
  sexp_round_head_wrap_element = "<localleader>e(",
  sexp_round_tail_wrap_element = "<localleader>e)",
  sexp_insert_at_list_head = "<localleader>eh",
  sexp_insert_at_list_tail = "<localleader>el",
}

vim.g.clojure_align_subforms = 1
vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
vim.g["conjure#mapping#log_reset_soft"] = "lc"
vim.g["conjure#mapping#log_reset_hard"] = "lC"


-- Plugins
require("user.plugin")
require("user.cmp")
require("user.lsp")

require("lualine").setup({
  options = { globalstatus = true },
})

require("bufferline").setup({
  options = { numbers = "buffer_id" },
  offsets = {
    { filetype = "nerdtree", text = "", padding = 1 },
    { filetype = "NvimTree", text = "", padding = 1 },
  },
})

require("Comment").setup({})
require("Comment.ft").set("clojure", ";;%s")

require("indent_blankline").setup({
  show_current_context = true,
  show_current_context_start = true,
  show_end_of_line = true,
  space_char_blankline = " ",
  context_patterns = {
    "class",
    "^func",
    "method",
    "^if",
    "while",
    "for",
    "with",
    "try",
    "except",
    "arguments",
    "argument_list",
    "object",
    "dictionary",
    "element",
    "table",
    "tuple",
    "do_block",
    "lit$",
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "clojure", "fennel", "lua", "ruby", "rust", "yaml", "markdown" },
  highlight        = { enable = true },
  indent           = { enable = true, disable = { "yaml" } },
})

local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules" },
    mappings = {
      i = { ["<C-t>"] = trouble.open_with_trouble,
            ["<C-j>"] = actions.cycle_history_prev,
            ["<C-k>"] = actions.cycle_history_next },
      n = { ["<C-t>"] = trouble.open_with_trouble,
            ["<C-j>"] = actions.cycle_history_prev,
            ["<C-k>"] = actions.cycle_history_next },
    },
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown {} },
  },
  pickers = {
    find_files = { find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" } }
  },
})
telescope.load_extension("ui-select")

require("trouble").setup {}


-- Keymaps
local keymap = vim.keymap.set
local km_opts = { noremap = true, silent = true }

keymap("", ",", "<nop>", km_opts)
keymap("", "<Space>", "<nop>", km_opts)
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

keymap("n", "<TAB>", ":bnext<CR>", km_opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", km_opts)
keymap("n", "<C-h>", ":lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<CR>", km_opts)
keymap("n", "<C-j>", ":lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<CR>", km_opts)
keymap("n", "<C-k>", ":lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<CR>", km_opts)
keymap("n", "<C-l>", ":lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<CR>", km_opts)
keymap("n", "<C-\\>", ":lua require('nvim-tmux-navigation').NvimTmuxNavigateLastActive()<CR>", km_opts)

keymap("n", "<leader>w", "<C-w>", km_opts)

keymap("n", "<leader>bd", ":Bdelete<CR>", km_opts)
keymap("n", "<leader>bd!", ":Bdelete!<CR>", km_opts)
keymap("n", "<leader>bw", ":Bwipeout<CR>", km_opts)
keymap("n", "<leader>bw!", ":Bwipeout!<CR>", km_opts)

keymap("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<CR>", km_opts)
keymap("n", "<leader>fr", ":lua require('telescope.builtin').oldfiles()<CR>", km_opts)
keymap("n", "<leader>fb", ":lua require('telescope.builtin').buffers()<CR>", km_opts)
keymap("n", "<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>", km_opts)
keymap("n", "<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>", km_opts)
keymap("n", "<leader>fs", ":lua require('telescope.builtin').grep_string()<CR>", km_opts)
keymap("n", "<leader>gC", ":lua require('telescope.builtin').git_commits()<CR>", km_opts)
keymap("n", "<leader>gc", ":lua require('telescope.builtin').git_bcommits()<CR>", km_opts)
keymap("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>", km_opts)
keymap("n", "<leader>gs", ":lua require('telescope.builtin').git_status()<CR>", km_opts)
keymap("n", "<leader>gS", ":lua require('telescope.builtin').git_stash()<CR>", km_opts)

keymap("n", "<leader>d", vim.diagnostic.open_float, km_opts)
keymap("n", "[d", vim.diagnostic.goto_prev, km_opts)
keymap("n", "]d", vim.diagnostic.goto_next, km_opts)
-- keymap("n", "<localleader>q", vim.diagnostic.setloclist, km_opts)

keymap("n", "<leader>tt", ":TroubleToggle<CR>", km_opts)
keymap("n", "<leader>tw", ":Trouble workspace_diagnostics<CR>", km_opts)
keymap("n", "<leader>td", ":Trouble document_diagnostics<CR>", km_opts)
keymap("n", "<leader>tq", ":Trouble quickfix<CR>", km_opts)
keymap("n", "<leader>tl", ":Trouble loclist<CR>", km_opts)
keymap("n", "<leader>tr", ":Trouble lsp_references<CR>", km_opts)
keymap("n", "<leader>ti", ":Trouble lsp_implementations<CR>", km_opts)
keymap("n", "[t", ":lua require('trouble').previous({skip_groups = true, jump = true})<CR>", km_opts)
keymap("n", "]t", ":lua require('trouble').next({skip_groups = true, jump = true})<CR>", km_opts)

keymap("n", "<leader>.", ":NERDTreeFind<CR>", km_opts)

keymap("v", "<CR>", "<Plug>(EasyAlign)", km_opts)
keymap({ "n", "x" }, "ga", "<Plug>(EasyAlign)", km_opts)

keymap("n", "'", "`", km_opts)
keymap("n", "`", "'", km_opts)
keymap("i", "jj", "<ESC>", km_opts)
keymap("v", "<A-j>", ":m .+1<CR>==", km_opts)
keymap("v", "<A-k>", ":m .-2<CR>==", km_opts)
keymap("v", "p", "\"_dP", km_opts)


-- Autocmd
vim.cmd [[
  augroup lisp_filetype
    autocmd!
    autocmd FileType clojure,fennel setlocal iskeyword-=.
    autocmd FileType clojure,fennel setlocal iskeyword-=/
    autocmd FileType clojure,fennel setlocal formatoptions+=or
    autocmd FileType clojure,fennel setlocal lispwords+=are,comment,cond,do,try
  augroup end
]]
