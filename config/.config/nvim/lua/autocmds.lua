local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name("NvFilePost")

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

-- newline comment continuation stops with esc + o now
-- add "r" to completely disable on newlines
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- wipe checkhealth buffers when we leave them
vim.api.nvim_create_autocmd("FileType", {
  pattern = "checkhealth",
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.bo[ev.buf].bufhidden = "wipe"
  end,
})

-- remember window view (scroll/topline, not just cursor pos) per buffer,
-- so jumping away (harpoon, :b, telescope) and back keeps zz/zt/etc.
do
  local views = {}
  local group = vim.api.nvim_create_augroup("RememberView", { clear = true })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then
        return
      end
      views[args.buf] = vim.fn.winsaveview()
    end,
  })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      local view = views[args.buf]
      if view then
        vim.fn.winrestview(view)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
      views[args.buf] = nil
    end,
  })
end
