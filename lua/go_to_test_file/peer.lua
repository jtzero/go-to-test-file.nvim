local project_generic = require('go_to_test_file.project_generic')
local list = require('go_to_test_file.list')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')

local peer = {}

peer.should_have_source_file = function(file_with_abs_path)
  local current_file_name = vim.fn.fnamemodify(file_with_abs_path, ':t')
  local test_file_identifiers = string.format("(%s|%s|%s)", list.unpack(project_generic.test_file_identifiers))
  local cmmd = 'printf "' .. current_file_name .. '" | rg "\\.' .. test_file_identifiers .. '\\."'
  local output = vim.fn.trim(vim.fn.system(cmmd))
  return output ~= ''
end

peer.find_source_file = function(file_with_abs_path)
  local test_filename = vim.fn.fnamemodify(file_with_abs_path, ':t')
  local matched = list.match_one(test_filename, project_generic.test_file_identifiers, '%.', '%.')
  local expected_source_code_filename = string.gsub(test_filename, matched, '.')
  local dir_abs_path = vim.fn.fnamemodify(file_with_abs_path, ':p:h')
  local cmmd = cmd.cd_string(dir_abs_path) .. " && fd -t f -E '^" .. test_filename .. "$' '" .. expected_source_code_filename .. "' | head -1"
  local ps = path.separator(system.name())
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, '')
  if vim.v.shell_error ~= 0 then
    error(output .. ' cmmd:' .. cmmd)
  end
  return path.join(ps, dir_abs_path, output)
end

peer.find_test_file = function(file_with_abs_path)
  local current_file_name_no_ext = vim.fn.fnamemodify(file_with_abs_path, ':t:r')
  local current_file_name = vim.fn.fnamemodify(file_with_abs_path, ':t')
  local fullpath = vim.fn.fnamemodify(file_with_abs_path, ':p:h')
  local test_file_identifiers = string.format("(%s|%s|%s)", list.unpack(project_generic.test_file_identifiers))
  local cmmd = cmd.cd_string(fullpath) .. " && fd -t f -E '" .. current_file_name .. "' '" .. current_file_name_no_ext ..
    "' | rg '" .. test_file_identifiers .. "' | head -n 1 "
  local ps = path.separator(system.name())
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, '')
  if vim.v.shell_error ~= 0 then
    error(output .. ' cmmd:' .. cmmd)
  end
  if output == '' then
    return ''
  else
    return path.join(ps, fullpath, output)
  end
end


return peer
