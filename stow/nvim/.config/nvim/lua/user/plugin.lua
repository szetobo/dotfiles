local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save this file
vim.cmd [[
  augroup packer_user_plugins
    autocmd!
    autocmd BufWritePost plugin.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use "lewis6991/impatient.nvim" -- Speed up loading Lua modules to improve startup time
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

  use "alexghergh/nvim-tmux-navigation" -- Easy Neovim-Tmux navigation
  use "farmergreg/vim-lastplace" -- Reopen files at your last edit position
  use "moll/vim-bbye" -- Delete buffers and close files without closing the window
  use "akinsho/bufferline.nvim" -- Buffer line
  use "preservim/nerdtree" -- File explorer
  use "ryanoasis/vim-devicons" -- Filetype glyphs (icons) for various plugins
  use "tpope/vim-repeat" -- Enable repeating keymap "." for supported plugins
  use "tpope/vim-surround" -- Add / Delete / Change surroundings parentheses / brackets / quotes / tags etc
  use "tpope/vim-unimpaired" -- Pairs of handy bracket mappings
  use "tpope/vim-projectionist" -- Project configuration
  use "tpope/vim-fugitive" -- Git wrapper
  use "AndrewRadev/splitjoin.vim" -- Switch between single & multi line forms of code
  use "junegunn/vim-easy-align" -- Alignment plugin
  use "lukas-reineke/indent-blankline.nvim" -- Display indention levels with thin vertical lines
  use "michaeljsmith/vim-indent-object" -- Define new text object representing same ident level
  use "numToStr/Comment.nvim" -- Easily comment stuff

  -- Colorschemes
  use "shaunsingh/nord.nvim"
  use "folke/tokyonight.nvim"
  use "kyazdani42/nvim-web-devicons" -- Filetype glyphs (icons) for various plugins
  use "nvim-lualine/lualine.nvim" -- Statusline plugin

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-telescope/telescope-ui-select.nvim" } },
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "jose-elias-alvarez/null-ls.nvim"
  use "folke/trouble.nvim"

  -- Completion plugins
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-nvim-lsp" -- lsp completions
  use "PaterJason/cmp-conjure" -- conjure completions

  -- Snippets
  use "L3MON4D3/LuaSnip" -- snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use
  use "saadparwaiz1/cmp_luasnip" -- snippet completions

  -- Rails
  use {
    "tpope/vim-rails",
    ft = { "ruby", "haml", "eruby", "coffee" },
  }

  -- Clojure
  use 'Olical/conjure'
  use "guns/vim-sexp"
  use "tpope/vim-sexp-mappings-for-regular-people"
  use {
    "eraserhd/parinfer-rust",
    run = "cargo build --release",
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
