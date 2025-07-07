local list = require('go_to_test_file.list')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')

local project_generic = {
  --deep_test_folder_prefixes = '(test|tests|spec)(/unit|/integration)?$',
  test_file_identifiers = { 'test', 'tests', 'spec' },
  src_folder_prefixes = { 'src', 'lib', 'app', 'lua' },
}

-- TODO remove path requiremewnt
project_generic.remove_test_file_name_identifiers = function(test_filename_rel_path_from_project)
  local filename, ext = list.unpack(path.split_on_ext(path.basename(test_filename_rel_path_from_project)))
  local prefix_path = path.dirname(test_filename_rel_path_from_project)
  local with_period = list.match_one(filename, project_generic.test_file_identifiers, '%.', '$')
  local with_underscore_prefix = list.match_one(filename, project_generic.test_file_identifiers, '_', '$')
  local with_underscore_suffix = list.match_one(filename, project_generic.test_file_identifiers, '^', '_')
  local result = filename
  if with_period ~= '' then
    result = string.gsub(filename, with_period, '')
  end
  if with_underscore_prefix ~= '' then
    result = string.gsub(result, with_underscore_prefix, '')
  end
  if with_underscore_suffix ~= '' then
    result = string.gsub(result, with_underscore_suffix, '')
  end
  if prefix_path == '.' then
    return result .. '.' .. ext
  else
    local ps = path.separator(system.name)
    return path.join(ps, prefix_path, result) .. '.' .. ext
  end
end

return project_generic
