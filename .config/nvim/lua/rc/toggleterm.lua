local M = {}

local KeyCode = {
  Up = "\x1b[A",
  Down = "\x1b[B",
  Right = "\x1b[C",
  Left = "\x1b[D",
}

local get_shell = function()
  local powershell_cmd =
    string.format("pwsh -NoLogo -NoProfile -NoExit -File %s ", vim.fn.expand "~/dotfiles/win/profile.ps1")
  local zsh_cmd = "zsh -l"
  return vim.fn.has "win64" == 1 and powershell_cmd or zsh_cmd
end

function M.config()
  require("toggleterm").setup {
    size = function(term)
      if term.direction == "horizontal" then
        return 10
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    start_in_insert = false,
    shell = get_shell(),
    env = {
      PARENT_NVIM_ADDRESS = vim.v.servername,
    },
    persist_size = true,
    float_opts = {
      winblend = 10,
    },
    on_open = function(term)
      local function send_key_action(key)
        return function()
          vim.api.nvim_chan_send(term.job_id, key)
        end
      end
      local opts = { noremap = true, buffer = term.bufnr }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jj", [[<C-\><C-n>]], opts)
      vim.keymap.set("n", "q", "<Cmd>close<CR>", opts)
      vim.keymap.set("n", "K", send_key_action(KeyCode.Up), opts)
      vim.keymap.set("n", "J", send_key_action(KeyCode.Down), opts)
      vim.keymap.set("n", "<CR>", send_key_action "\r", opts)

      -- gf
      vim.keymap.set("n", "gf", function()
        local cfile = vim.fn.expand "<cfile>"
        vim.cmd("close | e " .. cfile)
      end, opts)

      -- reload
      local reload = string.format("<Cmd>bdelete! | %dToggleTerm direction=%s<CR>", term.id, term.direction)
      vim.keymap.set("n", "<C-q>", reload, opts)

      -- cycle direction
      local direction_cycle = { "vertical", "horizontal", "float" }
      for idx, direction in pairs(direction_cycle) do
        if direction == term.direction then
          local next_idx = (idx % #direction_cycle) + 1
          local cmd = string.format("<Cmd>close | %dToggleTerm direction=%s<CR>", term.id, direction_cycle[next_idx])
          vim.keymap.set("n", "<leader><leader>", cmd, opts)
        end
      end
    end,
    direction = "float",
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    },
  }
end

return M
