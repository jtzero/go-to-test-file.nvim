return {
  row_with_smallest_first_item = function(table_to_search)
    local min = math.huge
    local idx = -1
    for i = 1, #table_to_search  do
      local new_min = min < table_to_search[i][1] and min or table_to_search[i][1]
      if new_min == 0 then
        idx = 1
        return idx
      else
        if new_min < min then
          min = new_min
          idx = i
        end
      end
    end
    return idx
  end
}
