local str = require('go_to_test_file.str')

describe('str', function()
  it('splits a string', function()

    assert(str.split("asdf,zxcv", ','))
  end)
end)
