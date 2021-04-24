return require('packer').startup(function()
    
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}
  
    -- Color scheme
    use { 'sainnhe/gruvbox-material' }
  
    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
  
    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    use { 'hrsh7th/nvim-compe' }

    -- snippet
    use { 'hrsh7th/vim-vsnip' }
    use { 'hrsh7th/vim-vsnip-integ' }

    -- highlingth syntax
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- status line
    use {'nvim-lua/lsp-status.nvim', otp = true}
  
    -- Lua development
    use { 'tjdevries/nlua.nvim' }
  
    -- Comment
    use {'tpope/vim-commentary'}
  
    -- Vim dispatch
    use { 'tpope/vim-dispatch' }
   
    -- Explore
    use { 'kyazdani42/nvim-tree.lua' }

    -- Icon
    use { 'kyazdani42/nvim-web-devicons' }

    -- vim sneak, movement
    use { 'justinmk/vim-sneak' }
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-surround' }

    -- close tag
    use { 'alvan/vim-closetag' }

    -- Vim <3 Tmux
    use { 'christoomey/vim-tmux-navigator' }

    -- Formater
    use { 'mhartington/formatter.nvim' }
    -- use { 'prettier/vim-prettier', run = 'yarn install' }
  
    -- Line for Git
    use {
        'glepnir/galaxyline.nvim',
          branch = 'main',
          -- your statusline
          config = function() require'galaxyline.spaceline' end,
          -- some optional icons
          requires = {'kyazdani42/nvim-web-devicons', opt = true}
      }
  
  end)
