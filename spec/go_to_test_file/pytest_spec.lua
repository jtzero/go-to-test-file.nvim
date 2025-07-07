local assert = require('luassert')

local path = require('go_to_test_file.path')
local system = require('go_to_test_file.system')
local pytest = require('go_to_test_file.pytest')
local helper = require('spec.helper')

describe('pytest', function()
  local original_buf_get_lines = vim.api.nvim_buf_get_lines
  after_each(function()
    vim.api.nvim_buf_get_lines = original_buf_get_lines
  end)
  describe('grep_source_file_from_buffer', function()
    it('will find the source file from the test file in the buffer', function()
      local ps = path.separator(system.name())
      local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_pytest_project')
      local test_file = path.join(
        path.separator(system.name),
        fixture_project_root,
        'go_to_test_file',
        'tests',
        'test_shopping_cart.py'
      )
      local line_iter = io.lines(test_file)
      local lines = {}
      for line in line_iter do
        table.insert(lines, line)
      end
      vim.api.nvim_buf_get_lines = function(_, _, _, _)
        return lines
      end
      local expected =
        path.join(path.separator(system.name), fixture_project_root, 'go_to_test_file', 'shopping_cart', '_base.py')

      local actual = pytest.grep_source_file_from_buffer(fixture_project_root)
      assert.are.equal(expected, actual)
    end)
  end)
  describe('grep_test_files_from_buffer', function()
    it('will find the test file from the file in the buffer', function()
      local ps = path.separator(system.name())
      local fixture_project_root = path.join(ps, helper.fixtures_path(), 'fake_pytest_project')
      local src_file =
        path.join(path.separator(system.name), fixture_project_root, 'go_to_test_file', 'shopping_cart', '_base.py')

      local line_iter = io.lines(src_file)
      local lines = {}
      for line in line_iter do
        table.insert(lines, line)
      end
      vim.api.nvim_buf_get_lines = function(_, _, _, _)
        return lines
      end

      local test_folder = path.join(path.separator(system.name), fixture_project_root, 'go_to_test_file', 'tests')
      local expected = path.join(path.separator(system.name), test_folder, 'test_shopping_cart.py')
      local actual = pytest.grep_test_files_from_buffer(test_folder)
      assert.are.equal(expected, actual)
    end)
  end)
end)
