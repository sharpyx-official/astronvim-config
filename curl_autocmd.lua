local function get_current_paragraph()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local rowi = row
  while true do
    local lastLine = vim.api.nvim_buf_get_lines(0, rowi, rowi + 1, false) or { "" }
    if lastLine[1] == "" then
      break
    end
    if lastLine[1] == nil then
      break
    end
    rowi = rowi + 1
  end

  local rowj = row
  while true do
    local lastLine = vim.api.nvim_buf_get_lines(0, rowj, rowj + 1, false) or { "" }
    if lastLine[1] == "" then
      break
    end
    if lastLine[1] == nil then
      break
    end

    rowj = rowj - 1

    if rowj < 1 then
      break
    end
  end

  local lines = vim.api.nvim_buf_get_lines(0, rowj, rowi, false)
  local result = table.concat(lines, " ")

  return result
end

local function ExecUrl()
  local cmd = get_current_paragraph()
  vim.api.nvim_command("tabnew | r ! " .. cmd)
end

vim.api.nvim_create_user_command("ExecUrl", ExecUrl, {})
