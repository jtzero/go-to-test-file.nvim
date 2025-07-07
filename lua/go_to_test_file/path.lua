-- replace with plenary
local system = require('go_to_test_file.system')

local path = {
  join = function(sep, a, ...)
    local memo = a
    for _, value in ipairs({ ... }) do
      memo = memo .. sep .. value
    end
    return memo
  end,
  -- ancestor has to be relative to PWD or you have to pass in abs
  difference_between_ancestor_folder_and_sub_folder = function(ancestor, sub_folder)
    local cmmd = 'realpath --relative-to="' .. ancestor .. '" "' .. sub_folder .. '"'
    return vim.fn.trim(vim.fn.system(cmmd))
  end,
}

-- TODO stop spot
path.check_path_upwards = function(start_path, names, stop_at)
  local found_path
  if stop_at then
    -- does this include the stop folder ?
    found_path = vim.fs.find(names, { upward = true, type = 'directory', path = start_path, stop = stop_at })[1]
  else
    found_path = vim.fs.find(names, { upward = true, type = 'directory', path = start_path })[1]
  end
  return found_path or ''
end

path.basename = function(filepath)
  return vim.fn.fnamemodify(filepath, ':t')
end

path.dirname = function(filepath)
  if filepath == '' then
    return ''
  end
  return vim.fn.fnamemodify(filepath, ':h')
end

path.filename_no_ext = function(filepath)
  return vim.fn.fnamemodify(filepath, ':t:r')
end

path.ext = function(filepath)
  return vim.fn.fnamemodify(filepath, ':e')
end

path.separator = function(system_name)
  if system_name == system.windows_name then
    return '\\'
  end
  return '/'
end

path.script_path = function(_)
  local caller_file_relative_to_cwd = debug.getinfo(2, 'S').source:sub(2)
  return vim.fn.fnamemodify(caller_file_relative_to_cwd, ':p:h')
end

path.split_on_ext = function(filename)
  local filename_no_ext = path.filename_no_ext(filename)
  return { filename_no_ext, path.ext(filename) }
end

return path
