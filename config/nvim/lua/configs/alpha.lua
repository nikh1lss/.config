local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#836EFF" }) -- ascii
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#a6adc8" }) -- buttons
vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#a6adc8" }) -- shortcuts
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#FF69D8" }) -- footer

local ascii = {
  "        ▁▁▁▔▔▕▗▖▁▁▁▁▁▁▁▁          ",
  "      ▁▁▁▁▁▁▁▁▁▏▁▔▘▁▁▁▁▖▁▁        ",
  "     ▕▕▖▘▝▗▃▁▐▚▇▇▁▃▛▜▍▏▕▉▏▏       ",
  "      ▕▁▁▝▐▏▄▐██▎▀▀▅▛▅█▏▁▏▖▁▁▏    ",
  "     ▕▁▔▕▕▝▜▀▂▞▔▔▂▂▔▔▗▂▆▀▔▁▗▏▏▁   ",
  "  ▕▁▁▁▕▏▁▂▂▏▕▀▘▆▃▇▉▘▝▇█▀▃▆▖▔▏▁▏▏  ",
  "  ▔▕▔▕▉▖▔▜█▏▙▅▅▏▁▅▅▕▟▍▅▏▔▏▁▁▁▏▔   ",
  "   ▁▁▁▔▔▔▕▏▜▀▗▆▁▆▜▕▋▖▔▔▁▁▁▁▔▔▏▏   ",
  "  ▕▕▔▔▂▁▁▔▔▔▕▔▔▔▔▕▀▋▔▃▏▘▔▕▔▔▏▏▏   ",
  "  ▕▕▕▔▔▘▘▁▖▔▔▔▕▂▏▕▔▔▔▔▔▁▁▕▕▏▏▏▏   ",
  "     ▕▏▏▔▝▘▏▁▁▏▔▔▔▔▕▁▏▔▔▔▔▔▔▏▔    ",
  "      ▔▔▕▁▔▔▔▔▔▔▔▏▔▔▔▔▔▔▔▔▔       ",
  "       ▕▔▔▔▔▔▔▏▁▁▁▁▖▏             ",
  "              ▕▕▗▆█▋▏             ",
  "             ▁▖▝███▋▏             ",
  "   ▁▁▁▁▁▁▏  ▕▕▘▁▝██▋▏             ",
  " ▁▁▂▖▗▃▗▖▏▏▔▔▕▕▂▟██▋              ",
  "▔▕▕▝▚▔▔▔▖▔▔▔▔▕▕▐▔██▋▏             ",
  "▕▕▕▔▝▔▔▔▗▂▁▁▔▕▕▟███▋▏             ",
  "         ▀▜▆▃▃▟████▋▏   ▁▁▁▁▁▕▁   ",
  "           ▔▀█▛█▎██▋▏  ▕▕▕▇▘▝▕▘▖▁ ",
  "              ▕▃▅██▋▏  ▔▔▕▝▀▎▀▘▏▔ ",
  "             ▕▕▜███▋▏ ▕▕▃▖▕▕▁▁▔▘▏▏",
  "             ▕▗▝████▅▅▇▛▀▔▔▔      ",
  "             ▕▝▗▞███▀▘▔           ",
  "             ▕▕▐▆██▋▏             ",
  "            ▕▁▁████▙▖▏            ",
  "           ▕▕▐▋▗████▙▎▏           ",
  "        ▁▁▁▕▃▛▘▐█████▆▃▃▁▁▁       ",
  "       ▕▏▝▗▛▀▋▝▔▜▀█▛▀▀▜▊▀▇▋▏      ",
}

-- Button definitions
local buttons = {
  { icon = "", key = "f", cmd = ":Telescope find_files<CR>" },
  { icon = "", key = "o", cmd = ":Telescope oldfiles<CR>" },
  { icon = "󰈭", key = "w", cmd = ":Telescope live_grep<CR>" },
  { icon = "󱥚", key = "p", cmd = ":Telescope persisted<CR>" },
  { icon = "", key = "h", cmd = ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>" },
}

-- Config
local left_col_width = 6
local right_col_width = 5
local ascii_width = 34
local start_row = 14
local spacing = 2
-- local total_width = left_col_width + ascii_width + right_col_width
local padding_top = 5 -- matches layout padding

-- Calculate which buffer lines are button rows
local button_rows = {}
for i = 1, #buttons do
  local ascii_row = start_row + (i - 1) * spacing
  button_rows[i] = ascii_row + padding_top
end

-- Build combined layout lines
local combined = {}

for i, line in ipairs(ascii) do
  local btn_index = math.floor((i - start_row) / spacing) + 1
  local is_button_row = (i >= start_row) and ((i - start_row) % spacing == 0) and (btn_index <= #buttons)

  local ascii_display_width = vim.fn.strdisplaywidth(line)
  local padded_ascii = line .. string.rep(" ", ascii_width - ascii_display_width)

  local left_text
  local right_text

  if is_button_row then
    local btn = buttons[btn_index]
    local icon_width = vim.fn.strdisplaywidth(btn.icon)
    left_text = btn.icon .. string.rep(" ", left_col_width - icon_width)
    right_text = string.rep(" ", right_col_width - 1) .. btn.key
  else
    left_text = string.rep(" ", left_col_width)
    right_text = string.rep(" ", right_col_width)
  end

  combined[i] = left_text .. padded_ascii .. right_text
end

-- Set header
dashboard.section.header.val = combined
dashboard.section.header.opts = {
  position = "center",
  hl = "AlphaHeader",
}

-- Namespaces (global so we can access them in multiple autocmds)
local ns = vim.api.nvim_create_namespace "alpha_custom_hl"
local cursor_ns = vim.api.nvim_create_namespace "alpha_cursor_hl"

-- Current button tracking
local current_btn = 1

-- Function to apply highlights
local function apply_highlights(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "alpha" then
    return
  end

  -- Clear existing highlights
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, btn in ipairs(buttons) do
    local row = button_rows[i] - 1
    local line = lines[row + 1]
    if line then
      -- Find icon at start
      local icon_start = line:find(btn.icon, 1, true)
      if icon_start then
        local icon_end = icon_start + #btn.icon
        vim.api.nvim_buf_add_highlight(bufnr, ns, "AlphaButtons", row, icon_start - 1, icon_end - 1)
      end

      -- Find shortcut key at end
      local shortcut_pos = #line - 1
      vim.api.nvim_buf_add_highlight(bufnr, ns, "AlphaShortcut", row, shortcut_pos, shortcut_pos + 1)
    end
  end
end

-- Function to update cursor highlight
local function update_cursor_highlight(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, cursor_ns, 0, -1)
  local row = button_rows[current_btn] - 1
  vim.api.nvim_buf_add_highlight(bufnr, cursor_ns, "AlphaCursorLine", row, 0, -1)
end

-- Function to move cursor to button
local function move_to_button(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local row = button_rows[current_btn]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local line = lines[row]
  local col = line and line:find "%S" or 0
  -- Wrap in pcall to catch any edge cases
  pcall(vim.api.nvim_win_set_cursor, 0, { row, col and col - 1 or 0 })
  update_cursor_highlight(bufnr)
end

-- Setup keymaps
local function setup_keymaps(bufnr)
  -- Check at the start of the function
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  -- j - move down (with wrap)
  vim.keymap.set("n", "j", function()
    if current_btn < #buttons then
      current_btn = current_btn + 1
    else
      current_btn = 1
    end
    move_to_button(bufnr)
  end, { buffer = bufnr, silent = true })

  -- k - move up (with wrap)
  vim.keymap.set("n", "k", function()
    if current_btn > 1 then
      current_btn = current_btn - 1
    else
      current_btn = #buttons
    end
    move_to_button(bufnr)
  end, { buffer = bufnr, silent = true })

  -- Enter - execute current button command
  vim.keymap.set("n", "<CR>", function()
    local cmd = buttons[current_btn].cmd
    if cmd ~= "" then
      vim.cmd(cmd:gsub("<CR>", ""))
    end
  end, { buffer = bufnr, silent = true })

  -- Direct shortcut keys
  for _, btn in ipairs(buttons) do
    if btn.cmd ~= "" then
      vim.keymap.set("n", btn.key, function()
        vim.cmd(btn.cmd:gsub("<CR>", ""))
      end, { buffer = bufnr, silent = true })
    end
  end
end

-- Initial setup when alpha loads
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    current_btn = 1 -- Reset to first button

    vim.defer_fn(function()
      apply_highlights(bufnr)
      move_to_button(bufnr)
      setup_keymaps(bufnr)
    end, 10)
  end,
})

-- Reapply highlights on resize
vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype == "alpha" then
      vim.defer_fn(function()
        apply_highlights(bufnr)
        update_cursor_highlight(bufnr)
      end, 50) -- slightly longer delay to let alpha re-render
    end
  end,
})

-- reapply button and shortcut highlights whenever we enter an alpha buffer
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype == "alpha" then
      vim.defer_fn(function()
        apply_highlights(bufnr)
        update_cursor_highlight(bufnr)
      end, 10)
    end
  end,
})

-- Also handle when alpha redraws
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.defer_fn(function()
      apply_highlights(bufnr)
      update_cursor_highlight(bufnr)
    end, 10)
  end,
})

-- Footer
dashboard.section.footer.val = ""
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Layout
dashboard.config.layout = {
  { type = "padding", val = padding_top },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

-- Footer update after lazy loads
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    local line = string.rep("─", 40)

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    current_btn = 1

    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      apply_highlights(bufnr)
      move_to_button(bufnr)
      pcall(setup_keymaps, bufnr) -- wrap in pcall to catch any race conditions
    end, 10)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    current_btn = 1

    -- Set keymaps immediately (no delay)
    setup_keymaps(bufnr)

    -- Highlights can stay deferred since they're visual only
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      apply_highlights(bufnr)
      move_to_button(bufnr)
    end, 10)
  end,
})
