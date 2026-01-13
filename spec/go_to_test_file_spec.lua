local assert = require('luassert')

local helper = require('spec.helper')

local go_to_test_file = require('go_to_test_file')
local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local cmd = require('go_to_test_file.cmd')

describe('go_to_test_file', function()
  describe('find_test_or_source_file_with_fallback', function()
    it('will find the test file of the file path passed in', function()
      local file_folder_abs_path = path.script_path(system.name)
      local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
      local git_root = vim.fn.trim(vim.fn.system(cmmd))

      local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
      local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
      local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
      assert.are.equal(expected, actual)
    end)
    it('will find the src file of the file path passed in', function()
      local file_folder_abs_path = path.script_path(system.name)
      local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
      local git_root = vim.fn.trim(vim.fn.system(cmmd))

      local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
      local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
      local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
      assert.are.equal(src_file, actual)
    end)
    describe('pytest', function()
      local original_nvim_buf_get_lines = vim.api.nvim_buf_get_lines
      after_each(function()
        vim.api.nvim_buf_get_lines = original_nvim_buf_get_lines
      end)
      it('will find the test file even when the "tests" are not in the root', function()
        local ps = path.separator(system.name)
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_pytest_project')
        local src_file = path.join(ps, fixture_project_root, 'go_to_test_file', 'shopping_cart', '_base.py')
        local expected_test_file =
          path.join(ps, fixture_project_root, 'go_to_test_file', 'tests', 'test_shopping_cart.py')

        local line_iter = io.lines(expected_test_file)
        local lines = {}
        for line in line_iter do
          table.insert(lines, line)
        end
        vim.api.nvim_buf_get_lines = function(_, _, _, _)
          return lines
        end

        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(expected_test_file, actual)
      end)
    end)
    describe('deep path', function()
      it('will find the test file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(expected, actual)
      end)
      it('will find the src file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(src_file, actual)
      end)
      it('will find the test file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
        local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(expected, actual)
      end)
      it('will find the src file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file.lua')
        local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(src_file, actual)
      end)
      it('will find the test file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local expected = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(expected, actual)
      end)
      it('will find the src file of the file path passed in', function()
        local file_folder_abs_path = path.script_path(system.name)
        local cmmd = cmd.cd_string(file_folder_abs_path) .. ' && git rev-parse --show-toplevel'
        local git_root = vim.fn.trim(vim.fn.system(cmmd))

        local src_file = path.join(path.separator(system.name), git_root, 'lua', 'go_to_test_file', 'list.lua')
        local test_file = path.join(path.separator(system.name), git_root, 'spec', 'go_to_test_file', 'list_spec.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(src_file, actual)
      end)
    end)
    describe('root_tests_project', function()
      it('will find the source file from the test file', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_root_tests_project')

        local test_file = path.join(ps, fixture_project_root, 'tests', 'go_to_test_file', 'shopping_cart_spec.lua')
        local expected_src_file = path.join(ps, fixture_project_root, 'src', 'go_to_test_file', 'shopping_cart.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(expected_src_file, actual)
      end)
      it('will find the source file from the test file in a deep path', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_root_tests_project')

        local test_file =
          path.join(ps, fixture_project_root, 'tests', 'go_to_test_file', 'shopping_cart', 'main_spec.lua')
        local expected_src_file =
          path.join(ps, fixture_project_root, 'src', 'go_to_test_file', 'shopping_cart', 'main.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(expected_src_file, actual)
      end)
    end)
    describe('in_module_tests_project', function()
      it('will find the source file from the test file', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_in_module_tests_project')

        local test_file = path.join(ps, fixture_project_root, 'go_to_test_file', 'tests', 'shopping_cart_spec.lua')
        local expected_src_file = path.join(ps, fixture_project_root, 'go_to_test_file', 'shopping_cart.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(expected_src_file, actual)
      end)
      it('will find the source file from the test file in a deep path', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_in_module_tests_project')

        local test_file =
          path.join(ps, fixture_project_root, 'go_to_test_file', 'tests', 'shopping_cart', 'main_spec.lua')
        local expected_src_file = path.join(ps, fixture_project_root, 'go_to_test_file', 'shopping_cart', 'main.lua')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(expected_src_file, actual)
      end)
    end)
    describe('peer_dunder_tests', function()
      it('will find the test file of the file path passed in', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake-peer-dunder-tests-project')

        local src_file = path.join(path.separator(system.name), fixture_project_root, 'src', 'app.js')
        local test_file = path.join(path.separator(system.name), fixture_project_root, 'src', '__tests__', 'app.js')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(test_file, actual)
      end)
      it('will find the src file of the file path passed in', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake-peer-dunder-tests-project')

        local src_file = path.join(path.separator(system.name), fixture_project_root, 'src', 'app.js')
        local test_file = path.join(path.separator(system.name), fixture_project_root, 'src', '__tests__', 'app.js')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(test_file)
        assert.are.equal(src_file, actual)
      end)
      it('will find the test file of the file path passed in even if the test file is infix', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake-peer-dunder-tests-project-infix')

        local src_file = path.join(path.separator(system.name), fixture_project_root, 'src', 'app.js')
        local test_file =
          path.join(path.separator(system.name), fixture_project_root, 'src', '__tests__', 'app.test.js')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(test_file, actual)
      end)
      it('will find test file in __tests__ when both __tests__ and tests directories exist', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake-peer-dunder-duplicate-tests-project')

        local src_file = path.join(path.separator(system.name), fixture_project_root, 'src', 'app.js')
        local test_file = path.join(path.separator(system.name), fixture_project_root, 'src', '__tests__', 'app.js')
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(test_file, actual)
      end)
    end)
    describe('peer', function()
      it('will find the test file of the src file path passed in', function()
        local ps = path.separator(system.name())
        local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake-peer-project')

        local src_file = path.join(
          path.separator(system.name),
          fixture_project_root,
          'src',
          'go-to-test-file',
          'fake-source-code-file.ts'
        )
        local test_file = path.join(
          path.separator(system.name),
          fixture_project_root,
          'src',
          'go-to-test-file',
          'fake-source-code-file.test.ts'
        )
        local actual = go_to_test_file.find_test_or_source_file_with_fallback(src_file)
        assert.are.equal(test_file, actual)
      end)
    end)
  end)
end)
