local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main",
  },
}
parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main",
  },
}

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    disable = {
      -- 'toml',
    },
  },
  ensure_installed = {
    "typescript",
    "tsx",
    "c",
    "cpp",
    "json",
    "yaml",
    "dockerfile",
    "vim",
    "lua",
    "comment",
    "html",
    "bash",
    "go",
    "rust",
    "norg",
    "norg_meta",
    "norg_table",
  },
}

require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ia"] = "@parameter.outer",
        ["aa"] = "@parameter.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["swn"] = "@parameter.inner",
      },
      swap_previous = {
        ["swp"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

require("nvim-treesitter.configs").setup {
  tree_docs = {
    enable = false,
    keymaps = {
      doc_all_in_range = "<space>h",
      doc_node_at_cursor = "<space>h",
    },
  },
}
