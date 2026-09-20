-- claudecode.nvim setup + local patches around the diff flow.
--
-- 1. Unsaved changes. Upstream aborts openDiff with a JSON-RPC error when the
--    target file is modified ("Cannot create diff: file has unsaved changes").
--    The Claude CLI still reports the diff as opened in Neovim, so the proposed
--    edit is lost with no way to get it back. Ask what to do instead:
--
--      Save and show diff    -- :w, then let Claude redo the edit against it
--      Discard and show diff -- :e! the buffer back to disk, then diff
--      Reject                -- leave the buffer untouched, tell Claude DIFF_REJECTED
--
--    Reject answers the request properly (the same payload as closing a diff
--    window), so Claude can retry or move on instead of waiting forever.
--
-- 2. Stale buffer after an accept. Accepting a diff only sends the content back
--    over MCP; the Claude CLI does the actual write. Neovim never notices that
--    write (nothing runs :checktime), so the file's buffer keeps showing the
--    pre-edit text. Reload it once the diff closes.
--
-- Why "Save" doesn't show the stale diff: the CLI reads the file, applies the
-- edit to that snapshot, and sends the result to openDiff; when the diff is
-- accepted its Edit tool re-checks the file against the content hash the
-- session recorded at read time and refuses to write if it changed ("File
-- content has changed since it was last read... Call Read on this file to
-- refresh, then retry"). Saving during the diff always trips that, whatever we
-- hand back, so the proposal on screen is already dead. Rather than make you
-- review a doomed diff, accept it unseen: the CLI's guard rejects the write,
-- Claude re-reads the saved file and proposes again, and that second diff --
-- the one computed against your saved work -- is the only one you review.

local M = {}

local options = {
  terminal = {
    provider = "none",
  },
  diff_opts = {
    open_in_new_tab = true,
    layout = "vertical",
  },
}

---Response Claude expects when the user declines a diff.
---@param tab_name string
local function rejected_response(tab_name)
  return {
    content = {
      { type = "text", text = "DIFF_REJECTED" },
      { type = "text", text = tab_name },
    },
  }
end

---Accept the proposal sight-unseen, handing back exactly what Claude proposed.
---Only used when the file on disk no longer matches what Claude read, so its
---own freshness guard is guaranteed to reject the write and force a re-read.
---@param new_file_contents string
local function force_reread_response(new_file_contents)
  return {
    content = {
      { type = "text", text = "FILE_SAVED" },
      { type = "text", text = new_file_contents },
    },
  }
end

---Loaded buffer whose name is exactly `path`, if any.
---@param path string
---@return integer|nil
local function buffer_for_path(path)
  local target = vim.fn.fnamemodify(path, ":p")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == target then
      return buf
    end
  end
  return nil
end

---@param path string
---@return string[]|nil
local function disk_lines(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and lines or nil
end

---@param bufnr integer
---@param cmd string
---@return boolean ok, string|nil err
local function run_in_buffer(bufnr, cmd)
  -- :edit in an autocmd window is fragile, so prefer a window already showing
  -- the buffer (any tab); nvim_buf_call is the fallback for hidden buffers.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      local win_ok, win_err = pcall(vim.api.nvim_win_call, win, function()
        vim.cmd(cmd)
      end)
      return win_ok, win_ok and nil or tostring(win_err)
    end
  end

  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd(cmd)
  end)
  return ok, ok and nil or tostring(err)
end

---Reload `path`'s buffer when it has fallen behind the file on disk.
---Never touches a modified buffer: unsaved work outranks Claude's write.
---@param path string
local function reload_from_disk(path)
  local bufnr = buffer_for_path(path)
  if not bufnr or vim.bo[bufnr].modified then
    return
  end

  local lines = disk_lines(path)
  if not lines or vim.deep_equal(lines, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) then
    return
  end

  local ok, err = run_in_buffer(bufnr, "silent edit!")
  if not ok then
    vim.notify("claudecode: could not reload " .. path .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end

---The CLI's write can land just after it asks us to close the diff tab, so
---check a few times rather than only on the event itself.
---@param path string
local function schedule_reload(path)
  for _, delay in ipairs({ 0, 250, 750 }) do
    vim.defer_fn(function()
      reload_from_disk(path)
    end, delay)
  end
end

---Ask what to do about `bufnr`'s unsaved changes and carry the answer out.
---@param bufnr integer
---@param path string
---@return "diff"|"redo"|"reject" verdict
local function resolve_unsaved_changes(bufnr, path)
  local choice = vim.fn.confirm(
    ("%s has unsaved changes.\nClaude's version was built from the file on disk."):format(
      vim.fn.fnamemodify(path, ":~:.")
    ),
    "&Save and show diff\n&Discard and show diff\n&Reject",
    1,
    "Question"
  )

  if choice == 1 then
    local before = disk_lines(path)
    local ok, err = run_in_buffer(bufnr, "silent write")
    if not ok or vim.bo[bufnr].modified then
      vim.notify("claudecode: could not save " .. path .. (err and (": " .. err) or ""), vim.log.levels.ERROR)
      return "reject"
    end

    local after = disk_lines(path)
    if before and after and not vim.deep_equal(before, after) then
      -- The file no longer matches what Claude read, so this proposal cannot be
      -- written; skip it and let Claude redo the edit against the saved file.
      vim.notify("claudecode: saved " .. path .. "; waiting for Claude's updated diff", vim.log.levels.INFO)
      return "redo"
    end

    -- Saving changed nothing on disk (an undone edit, say), so Claude's
    -- proposal still applies and is worth showing.
    return "diff"
  elseif choice == 2 then
    local ok, err = run_in_buffer(bufnr, "silent edit!")
    if not ok or vim.bo[bufnr].modified then
      vim.notify(
        "claudecode: could not discard changes to " .. path .. (err and (": " .. err) or ""),
        vim.log.levels.ERROR
      )
      return "reject"
    end
    return "diff"
  end

  -- 3 = Reject, 0 = prompt aborted (<Esc>/<C-c>); both leave the buffer as is.
  return "reject"
end

local patched = false

---Wrap diff.open_diff_blocking so unsaved changes prompt instead of erroring.
local function patch_open_diff_blocking()
  if patched then
    return
  end

  local diff = require("claudecode.diff")
  local open_diff_blocking = diff.open_diff_blocking

  diff.open_diff_blocking = function(old_file_path, new_file_path, new_file_contents, tab_name, client_id)
    local bufnr = buffer_for_path(old_file_path)
    if bufnr and vim.bo[bufnr].modified then
      local verdict = resolve_unsaved_changes(bufnr, old_file_path)
      if verdict == "reject" then
        return rejected_response(tab_name)
      elseif verdict == "redo" then
        return force_reread_response(new_file_contents)
      end
    end

    -- Any other setup failure would leave Claude believing the diff is open, so
    -- surface the error locally and answer the request as a rejection.
    local ok, result = pcall(open_diff_blocking, old_file_path, new_file_path, new_file_contents, tab_name, client_id)
    if not ok then
      local err = result
      if type(err) == "table" then
        err = table.concat({ err.message or "diff setup failed", err.data }, " - ")
      end
      vim.notify("claudecode: " .. tostring(err), vim.log.levels.ERROR)
      return rejected_response(tab_name)
    end
    return result
  end

  patched = true
end

function M.setup()
  require("claudecode").setup(options)
  patch_open_diff_blocking()

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("claudecode_diff_reload", { clear = true }),
    pattern = "ClaudeCodeDiffClosed",
    desc = "Pick up the file the Claude CLI wrote after a diff was accepted",
    callback = function(args)
      local path = args.data and args.data.file_path
      if path then
        schedule_reload(path)
      end
    end,
  })
end

return M
