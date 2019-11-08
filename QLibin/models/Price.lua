local utils = require("QLibin\\utils")
local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")



local function getHLOCFunc(hloc)
    if hloc == 'H' then return H end
    if hloc == 'L' then return L end
    if hloc == 'O' then return O end
    if hloc == 'C' then return C end
    return C -- default will be Close
end

local Price = Class(Base)

function Price:calc(index)
	if index > 0 then
        return getHLOCFunc(self.settings.hloc)(index)
    else
        return nil
    end
end

return Price
