--- TODO rename as this is perhaps a little too pytest specific

local path = require('go_to_test_file.path')
local cmd = require('go_to_test_file.cmd')
local system = require('go_to_test_file.system')
local str = require('go_to_test_file.str')

local pytest = {}

local remove_class_prefix_string = function(str)
  return string.match(str, 'class%s+(.+)')
end

local grep_for_classes = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local matches = {}
  for _, line in ipairs(lines) do
    local match = string.match(line, 'class%s+[A-z0-9_]+')
    if match then
      local match_without_test_prefix = remove_class_prefix_string(match):gsub('^Test', '')
      table.insert(matches, match_without_test_prefix)
    end
  end
  return matches
end

pytest.grep_source_file_from_buffer = function(source_folder_path, flags)
  flags = flags or { only_one_match = false }
  local class_names = grep_for_classes()
  if #class_names ~= 0 then
    local regex = '(' .. table.concat(class_names, '|') .. ')'
    if vim.fn.isdirectory(source_folder_path) == 0 then
      return ''
    end
    local cmd_for_class_grep = cmd.cd_string(source_folder_path) .. " && rg -l 'class " .. regex .. "'"
    local grepped_test_file = vim.fn.trim(vim.fn.system(cmd_for_class_grep))
    if vim.v.shell_error ~= 0 then
      error(source_folder_path .. ' cmd_for_class_grep:' .. cmd_for_class_grep)
    end
    local splitted = str.split(grepped_test_file, '\n')
    local first_item = splitted[1]
    if
      (first_item ~= '' and not flags.only_one_match)
      or (first_item ~= '' and flags.only_one_match and #splitted == 1)
    then
      local ps = path.separator(system.name())
      return path.join(ps, source_folder_path, first_item)
    else
      return ''
    end
  else
    return ''
  end
end

pytest.grep_test_files_from_buffer = function(test_folder_path)
  local class_names = grep_for_classes()
  if #class_names ~= 0 then
    local regex = '(' .. table.concat(class_names, '|') .. ')'
    local cmd_for_class_grep = cmd.cd_string(test_folder_path) .. " && rg -l 'Test" .. regex .. "' | head -n 1"
    local grepped_test_file = vim.fn.trim(vim.fn.system(cmd_for_class_grep))
    if vim.v.shell_error ~= 0 then
      error(test_folder_path .. ' cmd_for_class_grep:' .. cmd_for_class_grep)
    end
    if grepped_test_file ~= '' then
      local ps = path.separator(system.name())
      return path.join(ps, test_folder_path, grepped_test_file)
    else
      return ''
    end
  else
    return ''
  end
end

return pytest
