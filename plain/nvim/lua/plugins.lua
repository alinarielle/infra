return {
  -- gc<motion> for commenting
  'tomtom/tcomment_vim',
  -- "change surrounding ' to "": cs'"
  'tpope/vim-surround',
  -- makes tables with :Tabu
  'godlygeek/tabular',
  -- Better functionality for the % motion
  'andymass/vim-matchup',

  -- library
  'tpope/vim-dispatch',
  -- git integration
  'tpope/vim-fugitive',
  -- :SudoWrite, :Mkdir
  'tpope/vim-eunuch',
  -- autodetect indentation style
  'tpope/vim-sleuth',

  -- nice lua library for creating bindings
  '9999years/batteries.nvim',

  -- status line thingy
  'itchyny/lightline.vim',
  -- theme
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },

  -- library: run commands from lua asynchronously, etc
  -- python pathlib equivalent
  'nvim-lua/plenary.nvim',

  -- Telescope
  { 'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- nixos options search??
      'mrcjkb/telescope-manix',
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = 'false',
  },
}
