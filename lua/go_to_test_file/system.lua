local windows_name = 'WIN'
local linux_name = 'NIX'
local function is_win()
  return string.sub(package.config, 1,1) == '\\'
end

return {
  windows_name = windows_name,
  linux_name = linux_name,
  is_win = is_win,
  name = function()
    if is_win() then
      return windows_name
    else
      return linux_name
    end
  end
}
