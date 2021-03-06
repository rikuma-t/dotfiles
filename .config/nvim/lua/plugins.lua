local M = {}

function M.install_packer()
  local fn = vim.fn
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path .. "/lua/packer.lua")) > 0 then
    local out = fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    print(out)
  else
    print "already installed"
  end
end

local packer = nil
function M.init()
  if packer == nil then
    packer = require "packer"
    packer.init {
      disable_commands = true,
      display = {
        open_cmd = "lefta 65vnew \\[packer\\]",
      },
    }
  end

  local use = packer.use
  packer.reset()

  use { "wbthomason/packer.nvim", opt = true }
  use "lewis6991/impatient.nvim"
  use "vim-jp/vimdoc-ja"

  use {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = {
        "gina-status",
        "gina-commit",
        "TelescopePrompt",
        "toggleterm",
        "lir",
      }
    end,
  }

  -- lsp
  use {
    { "p00f/clangd_extensions.nvim" },
    { "Hoffs/omnisharp-extended-lsp.nvim" },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("rc.lsp").setup()
      end,
    },
    {
      "williamboman/mason.nvim",
      module = "mason",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      module = "mason-lspconfig",
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      module = "null-ls",
    },
  }

  use {
    "L3MON4D3/LuaSnip",
    requires = {
      "rafamadriz/friendly-snippets",
      "kleber-swf/vscode-unity-code-snippets",
    },
    config = function()
      require("rc.snippets").config()
    end,
    module = "luasnip",
  }

  -- cmp
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "onsails/lspkind-nvim",
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
    },
    config = function()
      require "rc.cmp"
    end,
    event = { "InsertEnter", "CmdlineEnter" },
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        char = "???",
        filetype_exclude = {
          "help",
          "toggleterm",
          "TelescopePrompt",
          "packer",
          "translator",
        },
      }
    end,
  }

  -- colorscheme
  use {
    {
      "sainnhe/everforest",
      config = function()
        vim.g.everforest_background = "hard"
        vim.g.everforest_ui_contrast = "high"
        vim.cmd [[ colorscheme everforest ]]
        --  vim.cmd [[ highlight! default link WinBar NormalFloat ]]
      end,
    },
    { "morhetz/gruvbox", disable = true },
    {
      "Matsuuu/pinkmare",
      config = function()
        vim.cmd [[autocmd ColorScheme * highlight SignColumn guibg=#202330]]
        vim.cmd [[autocmd ColorScheme * hi! MatchParen cterm=NONE,bold gui=NONE,bold,underline guibg=NONE guifg=NONE]]
        vim.cmd [[colorscheme pinkmare]]
      end,
      disable = true,
    },
  }

  use {
    "vim-denops/denops.vim",
    -- opt = true,
    config = function()
      if vim.fn.executable "deno" ~= 1 then
        vim.g["denops#deno"] = vim.fn.expand "~/.deno/bin/deno"
      end
      -- require("rc.denops").wait_ready()
    end,
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require "rc.autopairs"
    end,
    after = "nvim-cmp",
    event = "InsertEnter *",
  }

  use {
    "osyo-manga/vim-jplus",
    config = function()
      vim.keymap.set("n", "J", "<Plug>(jplus)", {})
      vim.keymap.set("v", "J", "<Plug>(jplus)", {})
      vim.keymap.set("n", "<leader>J", "<Plug>(jplus-getchar)", {})
      vim.keymap.set("v", "<leader>J", "<Plug>(jplus-getchar)", {})
      vim.g["jplus#config"] = { _ = {
        delimiter_format = "%d",
      } }
    end,
  }

  use {
    "haya14busa/vim-asterisk",
    config = function()
      vim.keymap.set("", "*", "<Plug>(asterisk-z*)", {})
      vim.keymap.set("", "#", "<Plug>(asterisk-z#)", {})
      vim.keymap.set("", "g*", "<Plug>(asterisk-gz*)", {})
      vim.keymap.set("", "g#", "<Plug>(asterisk-gz#)", {})
    end,
  }

  use {
    "tamago324/lir.nvim",
    setup = function()
      vim.keymap.set("n", "<leader>e", "<Cmd>MyLirOpen<CR>", { silent = true })
    end,
    config = function()
      require("rc.lir").config()
    end,
    cmd = { "MyLirOpen" },
  }

  use {
    "vim-skk/denops-skkeleton.vim",
    setup = function()
      vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)", {})
      vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-toggle)", {})
    end,
    config = function()
      require("rc.denops").register "skkeleton"
      require "rc.skkeleton"
    end,
    wants = "denops.vim",
    keys = {
      { "i", "<Plug>(skkeleton-toggle)" },
      { "c", "<Plug>(skkeleton-toggle)" },
    },
  }

  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
    module = "nvim-web-devicons",
    -- after = 'everforest',
  }

  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        patterns = {
          ".git",
          ".svn",
          "Makefile",
          "*.csproj",
          "*.sln",
        },
        detection_methods = { "pattern", "lsp" },
      }
    end,
  }
  use {
    "danymat/neogen",
    config = function()
      require("neogen").setup {
        enabled = true,
        languages = {
          cs = { template = { annotation_convention = "xmldoc" } },
        },
      }
      local generator = function(type)
        return function()
          require("neogen").generate { type = type }
        end
      end
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<Leader>hc", generator "class", opts)
      vim.keymap.set("n", "<Leader>hf", generator "func", opts)
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      setup = function()
        require("rc.telescope").setup()
      end,
      config = function()
        require("rc.telescope").config()
      end,
      module = "telescope",
      cmd = "Telescope",
    },
    {
      "nvim-telescope/telescope-packer.nvim",
      after = "telescope.nvim",
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension "fzf"
      end,
      run = "make",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension "live_grep_args"
      end,
    },
  }

  -- statusline
  use {
    {
      "rikuma-t/nvim-gps",
      config = function()
        require("nvim-gps").setup()
        function _G.nvim_gps_winbar()
          return require("nvim-gps").is_available() and require("nvim-gps").get_location() or ""
        end
        -- vim.wo.winbar = "%!v:lua.nvim_gps_winbar()"
      end,
    },
    {
      "NTBBloodbath/galaxyline.nvim",
      config = function()
        require "rc.statusline"
      end,
    },
  }

  use "mfussenegger/nvim-dap"

  use {
    {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
        require("rc.treesitter").config()
      end,
    },
    {
      "nvim-treesitter/playground",
      after = "nvim-treesitter",
      cmd = "TSPlaygroundToggle",
    },
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  }

  use {
    "voldikss/vim-translator",
    setup = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_source_lang = "auto"
      vim.g.translator_default_engines = { "google" }
      vim.g.translator_window_type = "popup"
      vim.keymap.set("n", "tr", "<Plug>TranslateW", { silent = true })
      vim.keymap.set("v", "tr", "<Plug>TranslateWV", { silent = true })
    end,
    keys = {
      { "n", "<Plug>TranslateW" },
      { "v", "<Plug>TranslateWV" },
    },
  }

  use {
    "rhysd/clever-f.vim",
    config = function()
      vim.g.clever_f_use_migemo = 1
    end,
  }

  -- git
  use {
    {
      "lambdalisue/gina.vim",
      setup = function()
        vim.keymap.set("n", ",s", ":<C-u>Gina status<CR>", {})
        vim.keymap.set("n", ",c", ":<C-u>Gina commit -v<CR>", {})
        vim.keymap.set("n", ",a", ":<C-u>Gina commit --amend -v<CR>", {})
        vim.keymap.set("n", ",b", ":<C-u>Gina branch -a<CR>", {})
        vim.keymap.set("n", ",l", ":<C-u>Gina log<CR>", {})

        local yank_cmd = "Gina browse --exact : --yank<CR>:let @+=@0"
        vim.keymap.set("n", ",y", "<Cmd>" .. yank_cmd .. "<CR>", { silent = true })
        vim.keymap.set("v", ",y", ":" .. yank_cmd .. "<CR>", { silent = true })

        local browse_cmd = "Gina browse --exact :"
        vim.keymap.set("n", ",x", "<Cmd>" .. browse_cmd .. "<CR>", { silent = true })
        vim.keymap.set("v", ",x", ":" .. browse_cmd .. "<CR>", { silent = true })
      end,
      cmd = { "Gina" },
    },
    {
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("rc.gitsigns").setup()
      end,
    },
  }

  -- textobj
  use {
    { "kana/vim-operator-user" },
    { "kana/vim-textobj-user" },
    {
      "kana/vim-operator-replace",
      config = function()
        vim.keymap.set("n", "_", "<Plug>(operator-replace)", { silent = true })
        vim.keymap.set("x", "_", "<Plug>(operator-replace)", { silent = true })
      end,
    },
    {
      "rhysd/vim-operator-surround",
      requires = { "kana/vim-operator-user" },
      config = function()
        vim.keymap.set("", "sa", "<Plug>(operator-surround-append)", { silent = true })
        vim.keymap.set("", "sd", "<Plug>(operator-surround-delete)", { silent = true })
        vim.keymap.set("", "sr", "<Plug>(operator-surround-replace)", { silent = true })
      end,
    },
    {
      "osyo-manga/vim-textobj-multiblock",
      config = function()
        vim.keymap.set("n", "sdd", "<Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)", { silent = true })
        vim.keymap.set("n", "srr", "<Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)", { silent = true })
        vim.keymap.set("o", "ib", "<Plug>(textobj-multiblock-i)", { silent = true })
        vim.keymap.set("o", "ab", "<Plug>(textobj-multiblock-a)", { silent = true })
        vim.keymap.set("v", "ib", "<Plug>(textobj-multiblock-i)", { silent = true })
        vim.keymap.set("v", "ab", "<Plug>(textobj-multiblock-a)", { silent = true })
      end,
    },
  }

  use {
    "mg979/vim-visual-multi",
    config = function()
      -- \\z normal
      vim.keymap.set("n", "<C-j>", "<Plug>(VM-Add-Cursor-Down)", { silent = true })
    end,
  }
  use "tpope/vim-repeat"
  use {
    "tyru/open-browser.vim",
    config = function()
      vim.keymap.set("n", "gx", "<Plug>(openbrowser-smart-search)", {})
      vim.keymap.set("v", "gx", "<Plug>(openbrowser-smart-search)", {})
    end,
  }

  use {
    "simplenote-vim/simplenote.vim",
    config = function()
      if vim.fn.filereadable(vim.fn.expand "~/.simplenote-credentials") then
        vim.cmd [[ source ~/.simplenote-credentials ]]
      end
      vim.g.SimplenoteFiletype = "simplenote-text"
      vim.g.SimplenoteListSize = 20
      au("FileType", { pattern = "simplenote-text", command = "setl cursorline" }).define()
    end,
    cmd = { "SimplenoteList" },
  }

  use { "PProvost/vim-ps1", ft = "ps1" }
  use { "hashivim/vim-vagrant", ft = "ruby" }
  use { "cespare/vim-toml", ft = "toml" }
  use { "kevinoid/vim-jsonc", ft = { "json", "jsonc" } }
  use { "aklt/plantuml-syntax", ft = "plantuml" }

  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown", "pandoc.markdown", "rmd", "plantuml" }
      vim.g.mkdp_preview_options = {
        uml = {
          server = "http://localhost:8080",
          imageFormat = "png",
        },
      }
    end,
    cmd = "MarkdownPreview",
    disable = true,
  }
  use {
    "nvim-neorg/neorg",
    ft = "norg",
    after = "nvim-treesitter",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
        },
      }
    end,
  }

  use {
    "lambdalisue/guise.vim",
    require = "denops.vim",
    config = function() end,
    disable = true,
  }
  use {
    "akinsho/toggleterm.nvim",
    setup = function()
      for i = 1, 5 do
        local key = string.format("<leader>%d", i)
        local cmd = string.format("<Cmd>exe %d . 'ToggleTerm'<CR>", i)
        vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
      end
    end,
    config = function()
      require("rc.toggleterm").config()
    end,
    cmd = "ToggleTerm",
  }

  use {
    "fatih/vim-go",
    config = function()
      vim.g.go_fmt_command = "goimports"
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
    end,
    ft = { "go" },
  }
  use {
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup()
    end,
  }
  -- test
  use {
    "hrsh7th/vim-searchx",
    config = function()
      local opts = { noremap = true }
      vim.keymap.set("n", "?", "<Cmd>call searchx#start({ 'dir': 0 })<CR>", opts)
      vim.keymap.set("n", "/", "<Cmd>call searchx#start({ 'dir': 1 })<CR>", opts)
      vim.keymap.set("x", "?", "<Cmd>call searchx#start({ 'dir': 0 })<CR>", opts)
      vim.keymap.set("x", "/", "<Cmd>call searchx#start({ 'dir': 1 })<CR>", opts)
      -- vim.keymap.set("c", ";", "<Cmd>call searchx#select()<CR>", opts)
      vim.keymap.set("n", "N", "<Cmd>call searchx#prev_dir()<CR>", opts)
      vim.keymap.set("n", "n", "<Cmd>call searchx#next_dir()<CR>", opts)
      vim.keymap.set("n", "N", "<Cmd>call searchx#prev_dir()<CR>", opts)
      vim.keymap.set("n", "n", "<Cmd>call searchx#next_dir()<CR>", opts)
      vim.keymap.set("c", "<C-p>", "<Cmd>call searchx#prev()<CR>", opts)
      vim.keymap.set("c", "<C-n>", "<Cmd>call searchx#next()<CR>", opts)
      vim.g.searchx = {
        auto_accept = true,
        scrolloff = 0,
        scrolltime = 0,
        nohlsearch = { jump = true },
        markers = vim.split("ABCDEFGHIJKLMNOPQRSTUVWXYZ", ""),
      }
      local old_scrolloff = vim.o.scrolloff
      aug("searchx_settings", {
        au("User", {
          pattern = "SearchxEnter",
          callback = function()
            old_scrolloff = vim.o.scrolloff
            vim.o.scrolloff = 0
          end,
        }),
        au("User", {
          pattern = "SearchxLeave",
          callback = function()
            vim.o.scrolloff = old_scrolloff
          end,
        }),
      })
      vim.cmd [[
        " Convert search pattern.
        function g:searchx.convert(input) abort
          if a:input !~# '\k'
            return '\V' .. a:input
          endif
          return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
        endfunction
      ]]
    end,
  }
end

return setmetatable(M, {
  __index = function(_, key)
    M.init()
    return packer[key]
  end,
})
