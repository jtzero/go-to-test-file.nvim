local project_generic = require('go_to_test_file.project_generic')
local git = require('go_to_test_file.git')
local peer = require('go_to_test_file.peer')
local root_tests = require('go_to_test_file.root_tests')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local list = require('go_to_test_file.list')
local project = require('go_to_test_file.project')
local peer_dunder_tests = require('go_to_test_file.peer_dunder_tests')
local pytest = require('go_to_test_file.pytest')

local go_to_test_file = {
  git = git,
  config = {
    print_command_result = true,
    print_main_command_result = false,
  },
}

go_to_test_file.match_dunder_test_folder_name_if_exists = function(test_folder_path, ps)
  return list.match_one(test_folder_path, peer_dunder_tests.test_folder_names, ps, '/?$', 'no_envelope')
end

go_to_test_file.find_test_or_source_file = function(git_root, current_file_abs_path)
  local ps = path.separator(system.name())
  local current_folder = path.dirname(current_file_abs_path)
  local currently_in_test_folder_path = project.test_path_from_filepath(current_file_abs_path)
  local filename_no_ext = path.filename_no_ext(current_file_abs_path)
  if currently_in_test_folder_path ~= '' then
    local dunder_test_folder_match =
      go_to_test_file.match_dunder_test_folder_name_if_exists(currently_in_test_folder_path, ps)
    local in_dunder_test_folder = dunder_test_folder_match ~= ''
    if in_dunder_test_folder then
      local currently_in_test_folder_path_length = string.len(currently_in_test_folder_path)
      local relative_path_in_test_folder =
        path.dirname(string.sub(current_file_abs_path, currently_in_test_folder_path_length + 1, -1)):gsub('/$', '')
      local source_folder = path.dirname(currently_in_test_folder_path) .. relative_path_in_test_folder
      local filename = path.basename(current_file_abs_path)
      return { peer_dunder_tests.find_source_file(source_folder, filename, dunder_test_folder_match), source_folder }
    else
      local branch_node = path.dirname(currently_in_test_folder_path)
      local test_foldername = path.basename(currently_in_test_folder_path)
      local filename = path.basename(current_file_abs_path)
      local test_filename_rel_path_from_project
      local path_in_test_folder =
        path.difference_between_ancestor_folder_and_sub_folder(currently_in_test_folder_path, current_folder)
      if path_in_test_folder == '.' then
        test_filename_rel_path_from_project = filename
        path_in_test_folder = ''
      else
        test_filename_rel_path_from_project = path.join(path_in_test_folder, filename)
      end
      local test_filename_without_test_identifiers =
        project_generic.remove_test_file_name_identifiers(test_filename_rel_path_from_project)
      local try_grep = pytest.grep_source_file_from_buffer(path.join(ps, branch_node, path_in_test_folder))
      if try_grep ~= '' then
        return { try_grep, path_in_test_folder }
      else
        -- TODO rename root_tests
        return {
          root_tests.find_source_file(
            branch_node,
            test_foldername,
            path_in_test_folder,
            test_filename_without_test_identifiers
          ),
          currently_in_test_folder_path,
        }
      end
    end
  elseif peer.should_have_source_file(current_file_abs_path) then
    return { peer.find_source_file(current_file_abs_path), current_folder }
  else
    -- this should happen before the walk up incase the walk up identifies an out of scope test folder
    local peer_test_code_file = peer.find_test_file(current_file_abs_path)
    if peer_test_code_file ~= '' then
      return { peer_test_code_file, current_folder }
    else
      local source_folder = path.dirname(current_file_abs_path)
      local test_folder_path = path.check_path_upwards(source_folder, project.test_folder_names)
      local test_foldername = path.basename(test_folder_path)
      local found_a_dunder_test_folder = list.match_one(test_foldername, peer_dunder_tests.test_folder_names) ~= ''
      if found_a_dunder_test_folder then
        return { peer_dunder_tests.find_test_file(test_folder_path, current_file_abs_path), test_folder_path }
      elseif test_folder_path ~= '' then
        local branch_node = path.dirname(test_folder_path)
        local prefix_path_in_source_folder =
          path.difference_between_ancestor_folder_and_sub_folder(branch_node, current_folder)
        local from_branch_node = path.join(ps, prefix_path_in_source_folder, filename_no_ext)
        local from_branch_node_without_src_folder = root_tests.remove_src_prefix_folder_from_path(from_branch_node, ps)
        local from_branch_node_without_src_folder_no_ext = vim.fn.fnamemodify(from_branch_node_without_src_folder, ':r')
        local test_file = root_tests.find_test_file(from_branch_node_without_src_folder_no_ext, test_folder_path)
        if test_file ~= '' then
          return { test_file, test_folder_path }
        else
          return { pytest.grep_test_files_from_buffer(test_folder_path), test_folder_path }
        end
      end
    end
  end
end

go_to_test_file.find_test_or_source_file_with_fallback = function(current_file_abs_path)
  local git_root = go_to_test_file.git.repo_root_of_file(current_file_abs_path)
  local filepath, test_path = list.unpack(go_to_test_file.find_test_or_source_file(git_root, current_file_abs_path))
  local ps = path.separator(system.name)

  if filepath == '.' .. ps or filepath == '' then
    if test_path ~= '' then
      return test_path
    else
      return git_root
    end
  else
    return filepath
  end
end

-- selene: allow(unscoped_variables, unused_variable)
GoToTestFile = go_to_test_file

go_to_test_file.setup = function(opts)
  opts = opts or {}

  vim.tbl_extend('force', go_to_test_file.config, opts)

  --vim.notify_once("go-to-test-file.nvim: you must use neovim 0.8 or higher")
  -- requirements rg, realpath, git, fd

  vim.api.nvim_create_user_command('FindTestOrSourceCodeFileWithFallback', function()
    local filepath = go_to_test_file.find_test_or_source_file_with_fallback(vim.fn.expand('%:p'))
    if go_to_test_file.config.print_main_command_result then
      print(filepath)
    end
    vim.cmd('e ' .. filepath)
  end, {})
end

return go_to_test_file
