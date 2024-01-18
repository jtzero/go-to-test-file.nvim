
local cmmd = {}

cmmd.cd_string = function(dir_path)
  return "cd " .. dir_path .. " > /dev/null"
end

return cmmd
