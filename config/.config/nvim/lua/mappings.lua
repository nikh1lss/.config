vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

-- visual block mode
vim.keymap.set("n", "<C-q>", "<C-v>", { noremap = true, desc = "visual block mode" })

-- keep navigation in normal mode
vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "move end of line" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "move right" })
-- vim.keymap.set("i", "<C-j>", "<Down>", { desc = "move down" })
-- vim.keymap.set("i", "<C-k>", "<Up>", { desc = "move up" })

vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
vim.keymap.set("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- for less visual clutter?
vim.keymap.set("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
vim.keymap.set("n", "<leader>N", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- global lsp vim.keymap.setpings
vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- buffer navigation
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })
-- vim.keymap.set("n", "<tab>", "<cmd>bnext<CR>", { desc = "buffer goto next" })
-- vim.keymap.set("n", "<S-tab>", "<cmd>bprevious<CR>", { desc = "buffer goto prev" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "buffer close" })

-- Comment
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
vim.keymap.set("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
vim.keymap.set(
  "n",
  "<leader>fz",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "telescope find in current buffer" }
)
vim.keymap.set("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
vim.keymap.set("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
vim.keymap.set(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- gitsigns
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "git toggle blame" })
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "git full file blame" })

-- terminal escape
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- moving
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move highlighted things" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move highlighted things" })

-- based
vim.keymap.set("n", "J", "mzJ'z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- quickfix
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>zz")

-- location list
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")
