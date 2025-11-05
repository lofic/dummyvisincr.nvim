-- Classical module pattern.
--
-- Creates an object for the module. All of the module's functions are
-- associated with this object (keys in the associative array),
-- which is returned when the module is called with `require`.
--
-- Tables in Lua are neither values nor variables; they are objects.
--
-- Usually it's M for module, a really common convention in plugins,
-- but it could be named differently.
-- the M.setup() function is also found is many plugins.

local M = {} -- table, here an associative array - aka hash, map, dictionary

M.upeven = function()
  -- Make every line whose number is even uppercase.
  -- The purpose is to test and demonstrate how to program in lua a simple action
  -- on some selected lines in nvim.

  local visual_start = vim.fn.getpos("'<")
  local visual_end = vim.fn.getpos("'>")
  -- get the start line and column of the selection
  local start_line = visual_start[2] - 1
  -- get the stop line and column of the selection
  local stop_line = visual_end[2] - 1

  -- all file
  --local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- selection only
  local lines = vim.api.nvim_buf_get_lines(0, start_line, stop_line + 1, false)

  for i, line in ipairs(lines) do
    if i % 2 == 0 then
      lines[i] = line:upper()
    end
  end

  -- all file
  --vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  -- selection only
  vim.api.nvim_buf_set_lines(0, start_line, stop_line + 1, false, lines)
end

M.incr = function()
  -- Visual block increment - increment a number.
  -- The purpose is to test and demonstrate how to program in lua a simple action
  -- on a selected block (visual block selection) in nvim.
  -- If you ned to get the idea, check the visincr plugin for vim.
  -- Note that you can easily increment numbers on a block selection
  -- NATIVELY in vim/neovim with g c-a (g ctrl-a).

  -- get the start line and column of the selection
  local visual_start = vim.fn.getpos("'<")
  -- get the stop line and column of the selection
  local visual_end = vim.fn.getpos("'>")

  -- visual block line start and end
  local start_line = visual_start[2] - 1
  local stop_line = visual_end[2] - 1

  -- visual block column start and end
  local start_col = visual_start[3]
  local stop_col = visual_end[3]

  -- put the lines of the selection in a table
  -- indexing is zero-based, end-exclusive
  local lines = vim.api.nvim_buf_get_lines(0, start_line, stop_line + 1, false)

  -- get the number to increment and optionally a padding from the first line
  local first_line = lines[1]
  local line_start = string.sub(first_line, 1, start_col - 1)
  local line_selection = string.sub(first_line, start_col, stop_col)
  local line_end = string.sub(first_line, stop_col + 1, string.len(first_line))
  local padding, start_number = string.match(line_selection, "(0*)(%d+)$")

  -- optional padding
  local str_fmt = ""
  if padding and padding ~= "" then -- in lua ~= means not equal to
    local padlen = string.len(padding)
    -- 001 -> 001
    -- 001 -> 002
    -- (...)
    str_fmt = "%" .. "0" .. padlen + 1 .. "d"
  else
    -- 9  -> 9
    -- 9  -> 10
    -- (..)
    str_fmt = "%d"
  end

  if start_number then
    local count = start_number
    -- loop through the lines of the selection and replace
    for i, line in ipairs(lines) do
      line_start = string.sub(line, 1, start_col - 1)
      line_selection = string.sub(line, start_col, stop_col)
      line_end = string.sub(line, stop_col + 1, string.len(first_line))
      lines[i] = line_start .. string.format(str_fmt, tostring(count)) .. line_end
      count = count + 1
    end
    vim.api.nvim_buf_set_lines(0, start_line, stop_line + 1, false, lines)
  else
    -- if we did not get a number in the selection, do nothing
    vim.print("The selection must be a number.")
  end
end

return M
