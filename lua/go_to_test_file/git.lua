local cmd = require('go_to_test_file.cmd')

return {
  repo_root_of_file = function(file_abs_path)
    local file_folder_abs_path = vim.fn.fnamemodify(file_abs_path, ":h")
    local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
    return vim.fn.trim(vim.fn.system(cmmd))
  end,
  repo_root_of_folder = function(folder_abs_path)
    local cmmd = cmd.cd_string(folder_abs_path) .. ' && git rev-parse --show-toplevel'
    return vim.fn.trim(vim.fn.system(cmmd))
  end
}
