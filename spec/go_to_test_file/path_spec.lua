local assert = require('luassert')
local helper = require('spec.helper')

local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')

describe('path', function()
  describe('dirname', function()
    it('removes the last segment in a path', function()
      local expected = 'asdf/qwer'
      local actual = path.dirname('asdf/qwer/zxcv')
      assert.are.equal(expected, actual)
    end)
  end)
  describe('basename', function()
    it('returns the last segment in a path', function()
      local expected = 'zxcv'
      local actual = path.basename('asdf/qwer/zxcv')
      assert.are.equal(expected, actual)
    end)
  end)
  describe('script_path', function()
    it('will print the relative path of the current script pathectory', function()
      local actual = path.script_path(system.name)
      local ps = path.separator(system.name())
      local expected = vim.fn.getcwd() .. ps .. 'spec' .. ps .. 'go_to_test_file'
      assert.are.equal(expected, actual)
    end)
  end)
  describe('difference_between_ancestor_folder_and_sub_folder', function()
    it('will print the relative path from subfolder to ancestor', function()
      local ps = path.separator(system.name())
      local this_path = vim.fn.getcwd() .. ps .. 'spec/go_to_test_file'
      local tst_abs_path = vim.fn.trim(vim.fn.system('realpath ./tst'))
      assert.are.equal(path.difference_between_ancestor_folder_and_sub_folder(this_path, tst_abs_path), '../../tst')
    end)
    it('will print the relative path from ancestor to subfolder even in a deep difference', function()
      local ps = path.separator(system.name)
      local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_root_tests_project')
      local deep_dir = path.join(ps, fixture_project_root, 'src', 'go_to_test_file', 'shopping_cart')
      assert.are.equal(
        path.difference_between_ancestor_folder_and_sub_folder(fixture_project_root, deep_dir),
        'src/go_to_test_file/shopping_cart'
      )
    end)
    it('will print the relative path from subfolder to ancestor even in a deep difference', function()
      local ps = path.separator(system.name)
      local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_root_tests_project')
      local deep_dir = path.join(ps, fixture_project_root, 'src', 'go_to_test_file', 'shopping_cart')
      assert.are.equal(
        path.difference_between_ancestor_folder_and_sub_folder(deep_dir, fixture_project_root),
        '../../..'
      )
    end)
    -- TODO returns file name if given in the second argument
  end)
  describe('join', function()
    it('joins multiple args into a file path', function()
      local expected = 'tst' .. path.separator(system.name) .. 'file.ts'
      local tst_filepath = path.join(path.separator(system.name), 'tst', 'file.ts')
      assert.are.equal(expected, tst_filepath)
    end)
  end)
  describe('split_on_ext', function()
    it('returns the filename and extension', function()
      local expected = { 'file.spec', 'ts' }
      local actual = path.split_on_ext('file.spec.ts')
      assert.are.same(expected, actual)
    end)
  end)
end)
