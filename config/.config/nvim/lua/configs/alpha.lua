local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- local img = dofile(vim.fn.stdpath("config") .. "/lua/configs/alpha_images/eyes.lua")
-- dashboard.config.layout[2] = img.header
dashboard.config.layout[1] = { type = "padding", val = 3 } -- top padding
-- dashboard.config.layout[3] = { type = "padding", val = 3 } -- bottom padding

dashboard.section.buttons.val = {
  dashboard.button("f", "λ  > Find file", ":Telescope find_files<CR>"),
  dashboard.button("o", "λ  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("w", "λ  > Grep", ":Telescope live_grep<CR>"),
  dashboard.button("p", "λ  > Sessions", ":Telescope persisted<CR>"),
  dashboard.button("h", "λ  > Marks", ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"),
}

-- Footer
-- vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#FF69D8" })
dashboard.section.footer.val = ""
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Seed the header with milli's first frame
local splashImage = "chrome"
local splash = require("milli").load({ splash = splashImage })
dashboard.config.layout[2] = {
  type = "text",
  val = splash.frames[1],
  opts = { position = "center", hl = "DashboardHeader" },
}
dashboard.config.layout[1] = { type = "padding", val = 3 }

alpha.setup(dashboard.opts)
require("milli").alpha({ splash = splashImage, loop = true })

-- Cursor wrapping for dashboard buttons
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function(ev)
    local buf = ev.buf
    local kopts = { buffer = buf, silent = true, noremap = true }

    local function get_button_lines()
      local positions = {}
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:match("λ") then
          table.insert(positions, i)
        end
      end
      return positions
    end

    vim.keymap.set("n", "j", function()
      local positions = get_button_lines()
      if #positions == 0 then
        return
      end
      local row = vim.api.nvim_win_get_cursor(0)[1]
      for _, pos in ipairs(positions) do
        if pos > row then
          vim.api.nvim_win_set_cursor(0, { pos, 0 })
          return
        end
      end
      vim.api.nvim_win_set_cursor(0, { positions[1], 0 })
    end, kopts)

    vim.keymap.set("n", "k", function()
      local positions = get_button_lines()
      if #positions == 0 then
        return
      end
      local row = vim.api.nvim_win_get_cursor(0)[1]
      for i = #positions, 1, -1 do
        if positions[i] < row then
          vim.api.nvim_win_set_cursor(0, { positions[i], 0 })
          return
        end
      end
      vim.api.nvim_win_set_cursor(0, { positions[#positions], 0 })
    end, kopts)
  end,
})

-- Lazy footer
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    local line = string.rep("─", 50)

    dashboard.section.footer.val = {
      { type = "text", val = line, opts = { hl = "AlphaFooter", position = "center" } },
      {
        type = "text",
        val = "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms",
        opts = { hl = "AlphaFooter", position = "center" },
      },
      { type = "text", val = line, opts = { hl = "AlphaFooter", position = "center" } },
    }
    dashboard.section.footer.type = "group"
    dashboard.section.footer.opts = { spacing = 0 }
    pcall(vim.cmd.AlphaRedraw)
  end,
})

-- Fix: force filetype detection when opening a file from alpha
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    vim.g.alpha_was_open = true
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if not vim.g.alpha_was_open then
      return
    end

    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local bt = vim.bo[buf].buftype

    if bt ~= "" or name == "" then
      return
    end

    vim.g.alpha_was_open = false

    vim.schedule(function()
      vim.cmd("doautocmd BufReadPost " .. vim.fn.fnameescape(name))
    end)
  end,
})
