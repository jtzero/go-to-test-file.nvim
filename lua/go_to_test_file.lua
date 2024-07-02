local project_generic = require('go_to_test_file.project_generic')
local git = require('go_to_test_file.git')
local peer = require('go_to_test_file.peer')
local root_tests = require('go_to_test_file.root_tests')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local list = require('go_to_test_file.list')
local project = require('go_to_test_file.project')
local peer_dunder_tests = require('go_to_test_file.peer_dunder_tests')

local go_to_test_file = {
  git = git,
  config = {
    print_command_result = true,
    print_main_command_result = false,
  }
}

GoToTestFile = go_to_test_file

go_to_test_file.find_src_folder_source_file_from_test_file = function(test_file_abs_path)
  local test_folder_path = project.test_path_from_filepath(test_file_abs_path)
  local filename_no_ext = path.filename_no_ext(test_file_abs_path)
  local project_root = root_tests.project_root_from_test_folder(test_folder_path)
  local test_foldername = path.basename(test_folder_path)
  local test_filename_without_test_identifiers = project_generic.remove_test_file_name_identifiers(filename_no_ext)
  local result = root_tests.find_source_file(project_root, test_foldername, test_filename_without_test_identifiers)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
end

go_to_test_file.find_test_folder_test_file_from_src_file = function(src_file_abs_path)
  local ps = path.separator(system.name())
  local git_root = go_to_test_file.git.repo_root_of_file(src_file_abs_path)
  local test_paths = root_tests.potential_test_folders(git_root)
  local test_folder = root_tests.nearest_test_folder(src_file_abs_path, test_paths)
  local project_root = root_tests.project_root_from_test_folder(test_folder)
  local project_root_length = string.len(project_root .. ps)
  local from_root = string.sub(src_file_abs_path, project_root_length + 1, -1)
  local src_folder_name = list.match_one(from_root, project_generic.src_folder_prefixes, '^', ps, 'no_envelope')
  local src_folder_length = string.len(src_folder_name .. ps)
  local from_root_without_src_folder = string.sub(from_root, src_folder_length + 1, -1)
  local from_root_without_src_folder_no_ext = vim.fn.fnamemodify(from_root_without_src_folder, ':r')
  local result = root_tests.find_test_file(from_root_without_src_folder_no_ext, test_folder)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
end

go_to_test_file.find_peer_source_file_from_test_file = function(test_file_abs_path)
  local result = peer.find_source_file(test_file_abs_path)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
  return result
end

go_to_test_file.find_peer_test_file_from_source_file = function(source_file_abs_path)
  local result = peer.find_test_file(source_file_abs_path)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
  return result
end

go_to_test_file.find_peer_dunder_source_file_from_test_file = function(test_file_abs_path)
  local filename = path.basename(test_file_abs_path)
  local test_folder_path = project.test_path_from_filepath(test_file_abs_path)
  local source_folder = path.dirname(test_folder_path)
  local result = peer_dunder_tests.find_source_file(source_folder, filename)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
  return result
end

go_to_test_file.find_peer_dunder_test_file_from_source_file = function(source_file_abs_path)
  local source_folder = path.dirname(source_file_abs_path)
  local filename = path.basename(source_file_abs_path)
  local result = peer_dunder_tests.find_source_file(source_folder, filename)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
  return result
end

go_to_test_file.find_test_or_source_file_from_either = function(current_file_abs_path)
  local git_root = go_to_test_file.git.repo_root_of_file(current_file_abs_path)
  local result = go_to_test_file.find_test_or_source_file(git_root, current_file_abs_path)
  if GoToTestFile.config.print_command_result then
    print(result)
  end
  return result
end

go_to_test_file.find_test_or_source_file = function(git_root, current_file_abs_path)
  local ps = path.separator(system.name())
  local current_folder = path.dirname(current_file_abs_path)
  if peer.should_have_source_file(current_file_abs_path) then
    return {peer.find_source_file(current_file_abs_path), current_folder}
  else
    local test_folder_path = project.test_path_from_filepath(current_file_abs_path)
    local filename_no_ext = path.filename_no_ext(current_file_abs_path)
    local match = list.match_one(test_folder_path, peer_dunder_tests.test_folder_names, ps, '/?$')
    if match and match ~= '' then
      local source_folder = path.dirname(test_folder_path)
      local filename = path.basename(current_file_abs_path)
      return {peer_dunder_tests.find_source_file(source_folder, filename), source_folder}
    elseif test_folder_path ~= '' then
      local project_root = root_tests.project_root_from_test_folder(test_folder_path)
      local test_foldername = path.basename(test_folder_path)
      local test_filename_without_test_identifiers = project_generic.remove_test_file_name_identifiers(filename_no_ext)
      return {root_tests.find_source_file(project_root, test_foldername, test_filename_without_test_identifiers), test_folder_path}
    else
      local source_folder = path.dirname(current_file_abs_path)
      local filename = path.basename(current_file_abs_path)
      local dunder_folder = peer_dunder_tests.folder_tests_folder(source_folder)
      if dunder_folder ~= '' then
        return {peer_dunder_tests.find_source_file(dunder_folder, filename), test_folder_path}
      else
        local peer_test_code_file = peer.find_test_file(current_file_abs_path)
        if peer_test_code_file ~= '' then
          return {peer_test_code_file, current_folder}
        else
          local test_paths = root_tests.potential_test_folders(git_root)
          local test_folder = root_tests.nearest_test_folder(current_file_abs_path, test_paths)
          local project_root = root_tests.project_root_from_test_folder(test_folder)
          local project_root_length = string.len(project_root .. ps)
          local from_root = string.sub(current_file_abs_path, project_root_length + 1, -1)
          local src_folder_name = list.match_one(from_root, project_generic.src_folder_prefixes, '^', ps, 'no_envelope')
          local src_folder_length = string.len(src_folder_name .. ps)
          local from_root_without_src_folder = string.sub(from_root, src_folder_length + 1, -1)
          local from_root_without_src_folder_no_ext = vim.fn.fnamemodify(from_root_without_src_folder, ':r')
          return {root_tests.find_test_file(from_root_without_src_folder_no_ext, test_folder), test_folder}
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

go_to_test_file.register_vim_cmds = function()
  vim.cmd('command! FindPeerSourceFile :lua GoToTestFile.find_peer_source_file_from_test_file(vim.fn.expand("%:p"))')
  vim.cmd('command! FindPeerTestFile :lua GoToTestFile.find_peer_test_file_from_source_file(vim.fn.expand("%:p"))')

  vim.cmd('command! FindSrcFolderSourceFile :lua GoToTestFile.find_src_folder_source_file_from_test_file(vim.fn.expand("%:p"))')
  vim.cmd('command! FindTestFolderTestFile :lua GoToTestFile.find_test_folder_test_file_from_src_file(vim.fn.expand("%:p"))')

  vim.cmd('command! FindPeerDunderSourceFile :lua GoToTestFile.find_peer_dunder_source_file_from_test_file(vim.fn.expand("%:p"))')
  vim.cmd('command! FindPeerDunderTestFile :lua GoToTestFile.find_peer_dunder_test_file_from_source_file(vim.fn.expand("%:p"))')

  vim.cmd('command! FindTestOrSourceFile :lua GoToTestFile.find_test_or_source_file_from_either(vim.fn.expand("%:p"))')
end

go_to_test_file.setup = function(opts)
  opts = opts or {}

  vim.tbl_extend('force', GoToTestFile.config, opts)

  --vim.notify_once("go-to-test-file.nvim: you must use neovim 0.8 or higher")
  -- requirements rg, realpath, git, fd

  vim.api.nvim_create_user_command("FindTestOrSrcCodeFileFolderOnFailure",
    function()
      local filepath = go_to_test_file.find_test_or_source_file_with_fallback(vim.fn.expand("%:p"))
      if GoToTestFile.config.print_main_command_result then
        print(filepath)
      end
      vim.cmd('e ' .. filepath)
    end,
    {}
  )
  go_to_test_file.register_vim_cmds()
end

return go_to_test_file
