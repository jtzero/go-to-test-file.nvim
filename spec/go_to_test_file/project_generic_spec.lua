local assert = require('luassert')

local project_generic = require('go_to_test_file.project_generic')

describe('project_generic', function()
  describe('remove_test_file_name_identifiers', function()
    it('removes the test folder identifiers from file name when .spec. is used', function()
      local test_file_rel_path = 'test/socket/my-file.spec.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('test/socket/my-file.ts', actual)
    end)
    it('removes the test folder identifiers from file name when .spec. is used in the filename and path', function()
      local test_file_rel_path = 'spec/socket/my-file.spec.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('spec/socket/my-file.ts', actual)
    end)
    it('removes the test folder identifiers from file name when delimited by underscores', function()
      local test_file_rel_path = 'tests/socket/my_file_spec.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('tests/socket/my_file.ts', actual)
    end)
    it('removes the test folder identifiers prefixes from file name when delimited by underscores', function()
      local test_file_rel_path = 'tests/socket/test_my_file.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('tests/socket/my_file.ts', actual)
    end)
    it('does not remove false positive test file identifies from file name when delimited by dashes', function()
      local test_file_rel_path = 'src/socket/socket-test-check.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('src/socket/socket-test-check.ts', actual)
    end)
    it('does not remove false positive test file identifies from file name when delimited by underscores', function()
      local test_file_rel_path = 'lua/go_to_test_file.lua'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('lua/go_to_test_file.lua', actual)
    end)
    it('passes the path in that it gets, and will not append ./', function()
      local actual = project_generic.remove_test_file_name_identifiers('app.js')
      assert.are.equal('app.js', actual)
    end)
  end)
end)
