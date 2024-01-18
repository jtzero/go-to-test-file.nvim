local assert = require('luassert')

local go_to_test_file = require('go_to_test_file')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')

describe('go_to_test_file', function()
  describe('find_test_or_src_code_file_folder_on_failure', function()
    it('will find the test file of the file path passed in', function()
      local file_folder_abs_path = path.script_path(system.name)
      local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
      local git_root = vim.fn.trim(vim.fn.system(cmmd))

      local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
      local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
      local actual = go_to_test_file.find_test_or_src_code_file_folder_on_failure(src_file)
      assert.are.equal(expected, actual)
    end)
    it('will find the src file of the file path passed in', function()
      local file_folder_abs_path = path.script_path(system.name)
      local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
      local git_root = vim.fn.trim(vim.fn.system(cmmd))

      local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
      local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
      local actual = go_to_test_file.find_test_or_src_code_file_folder_on_failure(test_file)
      assert.are.equal(src_file, actual)
    end)
    describe('deep path', function()
      it('will find the test file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_src_code_file_folder_on_failure(src_file)
        assert.are.equal(expected, actual)
      end)
      it('will find the src file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_src_code_file_folder_on_failure(test_file)
        assert.are.equal(src_file, actual)
      end)
    end)
  end)
end)
