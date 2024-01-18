local assert = require('luassert')

local path = require('go_to_test_file.path')
local git = require('go_to_test_file.git')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')

describe('git', function()
  describe('repo_root_of_file', function()
    it('returns true when in a test folder', function()

      local file_folder_abs_path = path.script_path(system.name)
      local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
      local expected = vim.fn.trim(vim.fn.system(cmmd))
      local actual = git.repo_root_of_file(path.join(path.separator(system.name), file_folder_abs_path, 'tst'))

      assert.are.equal(expected, actual)
    end)
  end)
end)
