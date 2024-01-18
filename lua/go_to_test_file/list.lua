local unpack_function = nil
if table['unpack'] then
  unpack_function = table['unpack']
else
  unpack_function = unpack
end

return {
  unpack = unpack_function,
  match_one = function(test_str, list, prefix, suffix, return_type)
    local exhausted = false
    local i = 1
    local found = ''
    while (not found) or (not exhausted) do
      if string.match(test_str, prefix .. list[i] .. suffix) then
        if return_type == 'no_envelope' then
          found = list[i]
        else
          found = prefix .. list[i] .. suffix
        end
      end
      i = i + 1
      if #list < i then
        exhausted = true
      end
    end
    return found or ''
  end,
  map = function(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
      t[k] = f(v)
    end
    return t
  end
}
