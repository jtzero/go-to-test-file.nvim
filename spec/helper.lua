local helper = {}

helper.root = function()
  local caller_file_relative_to_cwd = debug.getinfo(2, 'S').source:sub(2)
  local this_folder = vim.fn.fnamemodify(caller_file_relative_to_cwd, ':p:h')

  local cmmd = "cd " .. this_folder .. " > /dev/null" .. ' && git rev-parse --show-toplevel'
  return vim.fn.trim(vim.fn.system(cmmd))
end

helper.fixtures_path = function()
  local ps = string.sub(package.config, 1,1)
  return helper.root() .. ps .. 'fixtures'
end

return helper
