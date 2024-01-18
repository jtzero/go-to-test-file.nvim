local assert = require('luassert')

local project_generic = require('go_to_test_file.project_generic')

describe('project_generic', function()
  describe('remove_test_file_name_identifiers', function()
    it('removes the test folder identifiers from file name', function()
      local test_file_rel_path = 'src/socket/my-file.spec.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('src/socket/my-file.ts', actual)
    end)
    it('removes the test folder identifiers from file name when delimited by underscores', function()
      local test_file_rel_path = 'src/socket/my-file_spec.ts'
      local actual = project_generic.remove_test_file_name_identifiers(test_file_rel_path)
      assert.are.equal('src/socket/my-file.ts', actual)
    end)
  end)
end)
