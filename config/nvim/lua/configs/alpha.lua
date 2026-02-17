local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local function chafa_header(image_path, width, height)
  local cmd = string.format("chafa %s --size=%dx%d --symbols=braille --colors=none", image_path, width, height)
  local output = vim.fn.system(cmd)
  local lines = {}
  for line in output:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  return lines
end

local image = "PATH"

if vim.fn.executable("chafa") == 1 and (vim.fn.filereadable(image) == 1 or image == "PATH") then
  dashboard.section.header.val = { --[[ chafa_header(image, 100, 100) ]]
    "                                        ++*=          -.  ..                     ",
    "                                      :=+###*####=+*+####-                       ",
    "                   :  ++*=#* .       -#+#####*#############:                     ",
    "                    ########*===*+#++*###################                        ",
    "                  .+######################################.                      ",
    "                  ####@%#################################+:**                    ",
    "             :*+*###########################%################=+.-                ",
    "              :*######=#####%@%#################@%#@%############=               ",
    "               *#####################################@%%##########*=-            ",
    "           # =########%###%####%##################-.*####%###########*#*  - =    ",
    "           .#####@##@##############################= .#####################-     ",
    "          =####%@@%#*##+###-####%##%%#=#############*=#####*.=#############-     ",
    "           ##%############.  =-:*%@###################*#=+########%#########+    ",
    "      -=*=-######%@###@%#-:%*-*####@@%#%#%######@@#####+   *#######@@%##*+..     ",
    "      *#####%%####%####*#*.-.      -####@@#############++=@%%##############.     ",
    "       =+*#######:###*#####=+**       .  %#@@*#%#########=  -*######%######*     ",
    "         *##**   -######*#%###*##         =@%@-..+#*:  *#####*####%#@####*.*     ",
    "        .*#**################%###= ::      @@            ##-   +####**+.         ",
    "       *##########%######%######-#   %-   .@=             .      :*++            ",
    "       *############################*+ -@@%#.                                    ",
    "     =###*##*########################:   :@%                                     ",
    "      =#######+*#%#####+:-* .         #%# *@.                                    ",
    "     .=*######+=  +*:*###                -%%*                                    ",
    "          .   +        =                   @@*                                   ",
    "                                           *@#                                   ",
    "                                           #%#                                   ",
    "                                           %%-                                   ",
    "                                          *%#                                    ",
    "                                         *#%:                                    ",
    "                                        ***+                                     ",
    "                                       +##+-                                     ",
    "                             :-=+*#*##%#+%%@@@*::                                ",
    "                       :-++**#%%%##%***#*###%%%+=+##++**=:                       ",
    "                 .:-+++**#%##*%######%#***###%%#++======--=---:.                 ",
  }
else
  dashboard.section.header.val = { "  chafa not found or image missing  " }
end

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

alpha.setup(dashboard.opts)

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
