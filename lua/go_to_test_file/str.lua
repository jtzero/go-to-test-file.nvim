return {
  split = function(strg, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in strg:gmatch(regex) do
      table.insert(result, each)
    end
    return result
  end
}
