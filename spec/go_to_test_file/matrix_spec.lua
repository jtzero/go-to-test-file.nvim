local matrix = require('go_to_test_file.matrix')

describe('table', function()
  describe('row_with_smallest_first_item', function()
    it('finds the index of the row with the smallest first item', function()
      local test_table = { {9, '/lib'}, {1, '/etc'}, {2, '/root'} }
      assert.are.equal(2, matrix.row_with_smallest_first_item(test_table))
    end)
    it('finds the index of the row with the smallest first item, even when there is only one', function()
      local test_table = { {0, 'spec'} }
      assert.are.equal(1, matrix.row_with_smallest_first_item(test_table))
    end)
    it('returns -1 when the table is empty', function()
      local test_table = { }
      assert.are.equal(-1, matrix.row_with_smallest_first_item(test_table))
    end)

  end)
end)
