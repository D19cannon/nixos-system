-- lua/init.lua

-- Leader key
vim.g.mapleader = ' '

-- General options
local opt = vim.opt
opt.clipboard     = 'unnamedplus'
opt.mouse         = 'a'
opt.splitbelow    = true
opt.splitright    = true
opt.timeoutlen    = 500
opt.termguicolors = true
opt.completeopt   = 'menuone,noselect'
opt.updatetime    = 300
opt.tabstop       = 2
opt.shiftwidth    = 2
opt.softtabstop   = 2
opt.expandtab     = true
opt.shiftround    = true
opt.autoindent    = true
opt.smartindent   = true
opt.number        = true
opt.relativenumber= true
opt.wrap          = false
opt.cursorline    = true
opt.signcolumn    = 'yes'
opt.scrolloff     = 8
opt.sidescrolloff = 5
opt.ignorecase    = true
opt.smartcase     = true
opt.incsearch     = true
opt.hlsearch       = true
opt.swapfile      = false
opt.backup        = false
opt.writebackup   = false
opt.undofile      = true
opt.list          = true
opt.listchars     = { tab = '→ ', trail = '°', extends = '›', precedes = '‹' }
opt.foldmethod    = 'indent'
opt.foldlevel     = 99
opt.foldenable    = false

-- Key mappings
local keymap = vim.keymap.set
keymap('n', '<leader>w', ':w<CR>', { silent = false })
keymap('n', '<leader>q', ':q<CR>', { silent = false })
keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { silent = true })
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { silent = true })
keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { silent = true })
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { silent = true })
keymap('n', '<leader>lp', "<cmd>lua require('gitsigns').preview_hunk()<CR>", { silent = true })
keymap('n', '<leader>lg', '<cmd>LazyGit<CR>', { silent = true })

-- Colourscheme
vim.cmd[[colorscheme tokyonight-moon]]

-- Lualine
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    section_separators  = { left = '', right = '' },
    component_separators= { left = '', right = '' },
  },
})

-- Telescope setup with fzf-native
require('telescope').setup({
  defaults = {
    layout_config    = { prompt_position = 'top' },
    sorting_strategy = 'ascending',
  },
  pickers = {
    find_files = { hidden = true },
  },
  extensions = {
    fzf = {
      fuzzy            = true,
      override_file_sorter   = true,
      override_generic_sorter= true,
      case_mode        = 'smart_case',
    },
  },
})
require('telescope').load_extension('fzf')

-- Gitsigns
require('gitsigns').setup({
  attach_to_untracked    = true,
  current_line_blame     = true,
  current_line_blame_opts= { delay = 0, virt_text_pos = 'eol' },
})

-- indent-blankline
require('ibl').setup({
  indent = { char = '▏', tab_char = '▏' },
  scope  = {
    enabled    = true,
    show_start = true,
    show_end   = false,
  },
})

-- Dashboard (alpha-nvim) replicating your original header/buttons
local alpha    = require('alpha')
local dashboard= require('alpha.themes.dashboard')
dashboard.section.header.val = {
  '┌───────────────────────────┐',
  '│   Welcome back, <username>!     │',
  '└───────────────────────────┘',
}
dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
  dashboard.button('g', '  Live grep', ':Telescope live_grep<CR>'),
  dashboard.button('e', '  File tree', ':NvimTreeToggle<CR>'),
  dashboard.button('q', '  Quit', 'qa'),
}
dashboard.section.footer.val = { 'Tip: press ? for which-key' }
alpha.setup(dashboard.config)

-- LSP servers configuration using mason-lspconfig
-- Mason will automatically install and configure the language servers
require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
  ensure_installed = {
    'azure_pipelines_ls',              -- Azure Pipelines
    'cssls',                           -- CSS
    'docker_compose_language_service', -- Docker Compose
    'docker_language_server',          -- Docker
    'gopls',                           -- Go
    'html',                            -- HTML
    'jsonls',                          -- JSON
    'lua_ls',                          -- Lua
    'nginx_language_server',           -- Nginx
    'nixd',                            -- Nix
    'oxlint',                          -- JavaScript/TypeScript
    'ruff',                            -- Python
    'tailwindcss',                     -- Tailwind CSS
    'zls',                             -- Zig
  },
  handlers = {
    -- Default handler for all servers
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

