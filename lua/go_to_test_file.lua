local project_generic = require('go_to_test_file.project_generic')
local git = require('go_to_test_file.git')
local peer = require('go_to_test_file.peer')
local root_tests = require('go_to_test_file.root_tests')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local list = require('go_to_test_file.list')

local go_to_test_file = {
  git = git,
  peer = peer
}

--vim.cmd('command! FindSrcFolderSourceFile :lua print(GoToTestFile.root_tests.find_source_file(go_to_test_file.git.repo_root_of_file(vim.fn.expand("%:p")), vim.fn.expand("%:p")))')

--vim.cmd('command! FindTestFolderTestFile :lua print(GoToTestFile.root_tests.find_source_file(go_to_test_file.git.repo_root_of_file(vim.fn.expand("%:p")), vim.fn.expand("%:p")))')

vim.cmd('command! FindPeerSourceFile :lua print(GoToTestFile.peer.find_source_file(vim.fn.expand("%:p")))')

vim.cmd('command! FindPeerTestFile :lua print(GoToTestFile.peer.find_test_file(vim.fn.expand("%:p")))')

go_to_test_file.find_test_or_source_file = function(git_root, current_file_abs_path)
  local ps = path.separator(system.name())
  local folder = path.dirname(current_file_abs_path)
  if peer.should_have_source_file(current_file_abs_path) then
    return {peer.find_source_file(current_file_abs_path), folder}
  else
    local test_folder_path = root_tests.test_path_from_filepath(current_file_abs_path)
    local filename_no_ext = path.filename_no_ext(current_file_abs_path)
    if test_folder_path ~= '' then
      local project_root = root_tests.project_root_from_test_folder(test_folder_path)
      local test_foldername = path.basename(test_folder_path)
      local test_filename_without_test_identifiers = project_generic.remove_test_file_name_identifiers(filename_no_ext)
      return {root_tests.find_source_file(project_root, test_foldername, test_filename_without_test_identifiers), test_folder_path}
    else
      local peer_test_code_file = peer.find_test_file(current_file_abs_path)
      if peer_test_code_file ~= '' then
        return {peer_test_code_file, folder}
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

vim.cmd('command! FindTestOrSourceFile :lua print(GoToTestFile.find_test_or_source_file(go_to_test_file.git.repo_root_of_file(vim.fn.expand("%:p")), vim.fn.expand("%:p")))')

-- rename to last resort, the above should provide some sane locations even if it cannot find the file
go_to_test_file.find_test_or_src_code_file_folder_on_failure = function(current_file_abs_path)
  local git_root = go_to_test_file.git.repo_root_of_file(current_file_abs_path)
  local filepath, test_path = list.unpack(go_to_test_file.find_test_or_source_file(git_root, current_file_abs_path))
  local ps = path.separator(system.name)

  if filepath == '.' .. ps then
    if test_path ~= '' then
      return test_path
    else
      return git_root
    end
  else
    return filepath
  end
end

go_to_test_file.setup = function(opts)
  opts = opts or {}

  --vim.notify_once("go-to-test-file.nvim: you must use neovim 0.8 or higher")
  -- requirements rg, realpath, git, fd

  vim.api.nvim_create_user_command("FindTestOrSrcCodeFileFolderOnFailure",
    function()
      local filepath = go_to_test_file.find_test_or_src_code_file_folder_on_failure(vim.fn.expand("%:p"))
      print(filepath)
      vim.cmd('e ' .. filepath)
    end,
    {}
  )
  vim.keymap.set('n', '<M-T>', '<cmd>FindTestOrSrcCodeFileFolderOnFailure<CR>', {desc = 'Opens a corresponding test file or src file if not found opens the test folder', noremap = true})
end

GoToTestFile = go_to_test_file
return go_to_test_file
