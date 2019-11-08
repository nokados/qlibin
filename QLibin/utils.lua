local M = {}

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.log(data)
  PrintDbgStr(M.dump(data))
end

function M.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[M.copy(k, s)] = M.copy(v, s) end
  return res
end

function M.anyNil(...)
    if select('#', ...) == 0 then return false end
    local function helper(x, ...)
        if select('#', ...) == 0 then
          return x == nil
        end
        if x == nil then
            return true
        end
        return helper(...)
    end
    return helper(...)
end

return M

