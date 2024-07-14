-- Neovim Configuration

-- Bootstrap Packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

-- Plugin declarations
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'akinsho/toggleterm.nvim'
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  })
  use 'nvim-lualine/lualine.nvim'
  use 'folke/tokyonight.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'tpope/vim-fugitive'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'numToStr/Comment.nvim'
  use "windwp/nvim-autopairs"
  use "windwp/nvim-ts-autotag"
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'onsails/lspkind-nvim'
  use 'mbbill/undotree'
  use 'kevinhwang91/nvim-bqf'
  use 'lewis6991/gitsigns.nvim'
  use 'norcalli/nvim-colorizer.lua'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Snippets
--
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


-- Add the GraphQL snippet
ls.add_snippets("all", {
  s("gql", {
    t('const '),
    i(1, "MUTATION_NAME"),
    t(' = gql(/* GraphQL */ `'),
    t({ "", "  mutation " }),
    i(2, "mutationName"),
    t('('),
    i(3, "$var: Type!"),
    t(') {'),
    t({ "", "    " }),
    i(4, "mutationName"),
    t('(data: { '),
    i(5, "field: $var"),
    t(' }) {'),
    t({ "", "      " }),
    i(6, "field"),
    t({ "", "    }" }),
    t({ "", "  }" }),
    t({ "", "`);" })
  })
})

-- Expand snippet
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Jump backwards
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Select within a list of options
vim.keymap.set("i", "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- General settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.completeopt = 'menuone,noselect'
vim.opt.relativenumber = true

-- Key mappings
vim.g.mapleader = ' '

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

vim.api.nvim_set_keymap('n', '<leader>s', '<Plug>Ysurround', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>S', '<Plug>YSurround', { silent = true })


-- Window resizing
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')

-- Exit insert mode
map('i', 'jj', '<ESC>')

-- Pane navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- NvimTree
map('n', '<leader>nt', ':NvimTreeFocusFile<CR>', { desc = "Focus current file in NvimTree" })
map('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Telescope
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', { desc = "Find files" })
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = "Live grep" })
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = "Find buffers" })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = "Help tags" })

-- Diffview
map('n', '<leader>gh', ':DiffviewFileHistory %<CR>', { desc = "View git history for current file" })
map('n', '<leader>gq', ':DiffviewClose<CR>', { desc = "Close Diffview" })

-- LSP
map('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
map('n', 'K', vim.lsp.buf.hover, { desc = "Hover information" })
map('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation" })
map('n', '<leader>k', vim.lsp.buf.signature_help, { desc = "Signature help" })
map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map('n', '<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })
map('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "Type definition" })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action" })
map('n', 'gr', vim.lsp.buf.references, { desc = "Go to references" })
map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format code" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
map('n', 'gh', function()
  vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, { desc = "Show line diagnostics" })

-- Undotree
map('n', '<leader>u', ':UndotreeToggle<CR>', { desc = "Toggle Undotree" })

-- Plugin configurations

-- NvimTree
require('nvim-tree').setup({
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  renderer = {
    icons = {
      glyphs = {
        git = {
          unstaged = "M",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "x",
          ignored = "◌",
        },
      },
    },
  },
  view = {
    width = 30,
    side = 'left',
  },
  filters = {
    dotfiles = false,
  },
})

-- Telescope
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close
      },
    },
    file_ignore_patterns = { "node_modules", ".git" },
  },
  pickers = {
    live_grep = {
      additional_args = function(opts)
        return { "--hidden" }
      end
    },
  },
}

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { enable = true },
}

-- Toggleterm
require('toggleterm').setup {
  open_mapping = [[<C-`>]],
  direction = 'float',
}


-- Autotag
require('nvim-ts-autotag').setup()

-- Lualine
require('lualine').setup()

-- Color scheme
vim.cmd [[colorscheme tokyonight]]
vim.cmd [[
  highlight FloatBorder guifg=#3d59a1 guibg=#16161e
  highlight NormalFloat guibg=#16161e
]]

-- Null-LS (formatting)
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.rustfmt,
  },
})

-- Enable format on save
vim.cmd [[augroup FormatAutogroup]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })]]
vim.cmd [[augroup END]]

-- LSP and completion setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "tsserver", "rust_analyzer", "gopls" },
  automatic_installation = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
local servers = { 'lua_ls', 'pyright', 'tsserver', 'rust_analyzer', 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
    })
  }
}

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})


-- Gitsigns setup
require('gitsigns').setup()

-- Nvim-colorizer setup
require('colorizer').setup()

-- Comment.nvim setup
require('Comment').setup()

-- Nvim-autopairs setup
require('nvim-autopairs').setup {}

-- Nvim-ts-autotag setup
require('nvim-ts-autotag').setup()

-- Vim surroud setup
require("nvim-surround").setup({
})

-- Function to focus the current file in NvimTree
local function focus_file_in_tree()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" or current_file == nil then return end

  local nvim_tree_api = require('nvim-tree.api')

  if not nvim_tree_api.tree.is_visible() then
    nvim_tree_api.tree.open()
  end

  nvim_tree_api.tree.find_file(current_file)
end

vim.api.nvim_create_user_command('NvimTreeFocusFile', focus_file_in_tree, {})

-- Autocmd for Diffview keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "DiffviewFiles", "DiffviewFileHistory" },
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
    vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
    vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
    vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
  end,
})
