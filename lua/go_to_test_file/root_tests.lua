local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')
local matrix = require('go_to_test_file.matrix')
local list = require('go_to_test_file.list')
local str = require('go_to_test_file.str')

local root_tests = {
  test_folder_names = {'test', 'tests', 'spec'},
}

root_tests.test_path_from_filepath = function(current_file_with_abs_path)
  local ps = path.separator(system.name)
  local infix_match = list.match_one(current_file_with_abs_path, root_tests.test_folder_names, ps, ps)
  if infix_match == '' then
    return ''
  else
    local _, stop = string.find(current_file_with_abs_path, infix_match)
    return string.sub(current_file_with_abs_path, 1, stop):gsub(ps .. '$', '')
  end
end

root_tests.find_source_file = function(project_root_abs_path, test_foldername, path_in_test_folder, test_filename_without_test_identifiers)
  local ps = path.separator(system.name)
  local file_with_path = test_filename_without_test_identifiers
  if path_in_test_folder ~= '' then
    file_with_path = path.join(ps, path_in_test_folder, test_filename_without_test_identifiers)
  end
  local cmmd = cmd.cd_string(project_root_abs_path) .. " && fd -p -t f -E '" .. test_foldername .. "' '" .. file_with_path .. "([^" .. ps .. "]|$)' | head -1"
  local relative_path = vim.fn.trim(vim.fn.system(cmmd)):gsub("^." .. ps, "")
  return path.join(ps, project_root_abs_path, relative_path)
end

root_tests.project_root_from_test_folder = function(test_abs_path)
  return vim.fn.fnamemodify(test_abs_path, ":h")
end

-- fd added end slashes to dirs after 8.4.0
root_tests.potential_test_folders_regex = string.format("/(%s|%s|%s)/?$", list.unpack(root_tests.test_folder_names))

root_tests.potential_test_folders = function(dir)
  local ps = path.separator(system.name())
  local cmmd = cmd.cd_string(dir) .. " && fd -t d -p '" .. root_tests.potential_test_folders_regex .. "'"
  local result = vim.fn.system(cmmd)
  if vim.v.shell_error ~= 0 then
    error(result .. ' cmmd:' .. cmmd)
  end
  return list.map(str.split(result, '\n'), function(item)
    local strg = item:gsub('^.' .. ps, ''):gsub(ps .. '$', '')
    return path.join(ps, dir, strg)
  end)
end

root_tests.nearest_test_folder = function(source_file_folder_abs_path, possible_test_paths)
  local ps = path.separator(system.name())
  local hops = {}
  for _,v in pairs(possible_test_paths) do
    local relpath = path.difference_between_ancestor_folder_and_sub_folder(source_file_folder_abs_path, v)
    local _, count = string.gsub(relpath, ps, {})
    table.insert(hops, {count, v})
  end
  local idx = matrix.row_with_smallest_first_item(hops)
  return hops[idx][2]
end

root_tests.find_test_file = function(from_root_without_src_folder_no_ext, test_folder)
  local ps = path.separator(system.name())
  local cmmd = ''
  if string.find(from_root_without_src_folder_no_ext, path.separator(system.name)) then
    cmmd = cmd.cd_string(test_folder) .. " && fd -t f -p '" .. from_root_without_src_folder_no_ext .. "' | head -n 1 "
  else
    cmmd = cmd.cd_string(test_folder) .. " && fd -t f '" .. from_root_without_src_folder_no_ext .. "' | head -n 1 "
  end
  local test_file_from_root = vim.fn.trim(vim.fn.system(cmmd)):gsub("^." .. ps, "")
  if vim.v.shell_error ~= 0 then
    error(test_file_from_root .. ' cmmd:' .. cmmd)
  end
  if test_file_from_root == '' then
    return ''
  else
    return path.join(ps, test_folder, test_file_from_root)
  end
end

return root_tests
