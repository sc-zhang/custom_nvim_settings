-- Close mouse support
vim.opt.mouse = ""

-- Set row number as relative
vim.opt.relativenumber = true

-- Restore lastest edit position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { mark[1], mark[2] })
    end
  end,
})

-- Duplicate current line downward and move cursor to the duplicated line (same column)
local function duplicate_line_down_and_move()
  local win, buf = 0, 0

  local pos = vim.api.nvim_win_get_cursor(win) -- {row(1-based), col(0-based)}
  local row, col = pos[1], pos[2]

  -- Current line text
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, true)[1] or ""

  -- Insert copy below
  vim.api.nvim_buf_set_lines(buf, row, row, true, { line })

  -- Move cursor to the new line, same column
  -- (row+1 exists now)
  vim.api.nvim_win_set_cursor(win, { row + 1, col })
end

vim.keymap.set("n", "<leader>d", duplicate_line_down_and_move, { desc = "Duplicate line down (move cursor)" })

local function duplicate_visual_lines_down()
  local win, buf = 0, 0

  -- save current cursor col
  local cur = vim.api.nvim_win_get_cursor(win)
  local col = cur[2]

  -- get visual range via marks (1-based row, 0-based col)
  local s = vim.api.nvim_buf_get_mark(buf, "<")
  local e = vim.api.nvim_buf_get_mark(buf, ">")
  local srow, erow = s[1], e[1]
  if srow == 0 or erow == 0 then return end
  if srow > erow then srow, erow = erow, srow end

  -- exit visual mode to avoid weirdness
  vim.cmd("normal! \27")

  -- copy whole lines in [srow, erow]
  local lines = vim.api.nvim_buf_get_lines(buf, srow - 1, erow, true)
  if #lines == 0 then return end

  -- insert below the selection
  vim.api.nvim_buf_set_lines(buf, erow, erow, true, lines)

  -- move to first line of duplicated block, same column
  vim.api.nvim_win_set_cursor(win, { erow + 1, col })
end

vim.keymap.set("x", "<leader>d", duplicate_visual_lines_down, { desc = "Duplicate visual lines down (move cursor)", silent = true })


-- Avoid cursor move to left character after ESC pressed
vim.keymap.set("i", "<ESC>", "<ESC>`^", {noremap=true})

