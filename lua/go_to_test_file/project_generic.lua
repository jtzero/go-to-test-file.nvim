local list = require('go_to_test_file.list')

local project_generic = {
  --deep_test_folder_prefixes = '(test|tests|spec)(/unit|/integration)?$',
  test_file_identifiers = {'test', 'tests', 'spec'},
  src_folder_prefixes = {'src', 'lib', 'app', 'lua'},
}

project_generic.remove_test_file_name_identifiers = function(test_filename_rel_path_from_project)
  local with_period = list.match_one(test_filename_rel_path_from_project, project_generic.test_file_identifiers, '%.', '')
  local with_underscore = list.match_one(test_filename_rel_path_from_project, project_generic.test_file_identifiers, '_', '')
  local path_without_infixes = string.gsub(test_filename_rel_path_from_project, with_period, '')
  path_without_infixes = string.gsub(path_without_infixes, with_underscore, '')

  return path_without_infixes
end

return project_generic
