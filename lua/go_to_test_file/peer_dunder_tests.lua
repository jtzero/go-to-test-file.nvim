local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')
local list = require('go_to_test_file.list')

local peer_dunder_tests = {
  test_folder_names = {'__tests__'}
}

peer_dunder_tests.find_source_file = function(source_folder, filename)
  local ps = path.separator(system.name())
  local cmmd = cmd.cd_string(source_folder) .. " && fd --type f --max-depth=1 '" .. filename .. "' | head -1"
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, '')
  if vim.v.shell_error ~= 0 then
    error(output .. ' cmmd:' .. cmmd)
  end
  if output == '' then
    return ''
  else
    return path.join(ps, source_folder, output)
  end
end

peer_dunder_tests.find_test_file = peer_dunder_tests.find_source_file

peer_dunder_tests.folder_tests_folder = function(source_folder)
  local ps = path.separator(system.name())
  local identifiers = string.format("^%s/?$", list.unpack(peer_dunder_tests.test_folder_names))
  local cmmd = cmd.cd_string(source_folder) .. " && fd --type d --max-depth=1 '" .. identifiers .. "' | head -1"
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, '')
  if vim.v.shell_error ~= 0 then
    error(output .. ' cmmd:' .. cmmd)
  end
  if output == '' then
    return ''
  else
    return path.join(ps, source_folder, output)
  end
end
return peer_dunder_tests
