local assert = require('luassert')

local list = require('go_to_test_file.list')

describe('list', function()
  describe('match_one', function()
    it('returns the first pattern that matches the test_str', function()
      local patterns = {'...x', '..x.', '.x..'}
      local actual = list.match_one('zxcv', patterns, '', '')
      assert.are.equal('.x..', actual)
    end)
    it('returns the first pattern that matches the test_str with prefix or suffix', function()
      local patterns = {'qwer', 'zxcv', 'asdf'}
      local actual = list.match_one('zxcv/poiuy.lua', patterns, '^', '/')
      assert.are.equal('^zxcv/', actual)
    end)
    it('returns the first pattern that matches the test_str without the envelope', function()
      local patterns = {'qwer', 'zxcv', 'asdf'}
      local actual = list.match_one('zxcv/poiuy.lua', patterns, '^', '/', 'no_envelope')
      assert.are.equal('zxcv', actual)
    end)
  end)
end)
