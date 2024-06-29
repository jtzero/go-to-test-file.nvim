local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local list = require('go_to_test_file.list')
local root_tests = require('go_to_test_file.root_tests')
local peer_dunder_tests = require('go_to_test_file.peer_dunder_tests')

local project = {}

project.test_folder_names = vim.list_extend(vim.list_extend({}, root_tests.test_folder_names), peer_dunder_tests.test_folder_names)

project.test_path_from_filepath = function(current_file_with_abs_path)
  local ps = path.separator(system.name)
  local infix_match = list.match_one(current_file_with_abs_path, project.test_folder_names, ps, ps)
  if infix_match == '' then
    return ''
  else
    local _, stop = string.find(current_file_with_abs_path, infix_match)
    return string.sub(current_file_with_abs_path, 1, stop):gsub(ps .. '$', '')
  end
end

return project
