local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')
local list = require('go_to_test_file.list')

local project_generic = require('go_to_test_file.project_generic')

local peer_dunder_tests = {
  test_folder_names = { '__tests__' },
}

peer_dunder_tests.find_source_file = function(source_folder, test_filename, test_folder_name)
  local ps = path.separator(system.name())
  local test_filename_without_test_identifiers = project_generic.remove_test_file_name_identifiers(test_filename)
  local test_filename_without_test_identifiers_no_ext, ext =
    list.unpack(path.split_on_ext(test_filename_without_test_identifiers))
  local cmmd = cmd.cd_string(source_folder)
    .. " && fd -i -t f --max-depth=1 -E '"
    .. test_folder_name
    .. "' '"
    .. test_filename_without_test_identifiers_no_ext
    .. '\\.('
    .. ext
    .. '|[a-zA-Z0-9]{2,4})?$'
    .. "' | head -1"
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

peer_dunder_tests.find_test_file = function(test_folder, source_filepath)
  local ps = path.separator(system.name())
  local branch_node_path = path.dirname(test_folder)
  local prefix_path =
    path.difference_between_ancestor_folder_and_sub_folder(branch_node_path, path.dirname(source_filepath))
  local source_filename = path.basename(source_filepath)
  local filename_no_ext, ext = list.unpack(path.split_on_ext(source_filename))
  local test_folder_with_prefix_path = ''
  if prefix_path == '.' then
    test_folder_with_prefix_path = test_folder
  else
    test_folder_with_prefix_path = path.join(ps, test_folder, prefix_path)
  end
  local cmmd = cmd.cd_string(test_folder_with_prefix_path)
    .. " && fd -i -t f --max-depth=1 '"
    .. filename_no_ext
    .. '\\.('
    .. ext
    .. '|[a-zA-Z0-9]{2,4})?$'
    .. "' | head -1"
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, '')
  if vim.v.shell_error ~= 0 then
    error(output .. ' cmmd:' .. cmmd)
  end
  if output == '' then
    return ''
  else
    return path.join(ps, test_folder_with_prefix_path, output)
  end
end

peer_dunder_tests.folder_tests_folder = function(source_folder)
  local ps = path.separator(system.name())
  local identifiers = string.format('^%s/?$', list.unpack(peer_dunder_tests.test_folder_names))
  local cmmd = cmd.cd_string(source_folder) .. " && fd -t d --max-depth=1 '" .. identifiers .. "' | head -1"
  local output = vim.fn.trim(vim.fn.system(cmmd)):gsub('^.' .. ps, ''):gsub(ps .. '$', '')
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
