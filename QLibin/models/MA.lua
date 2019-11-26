local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")
local Price = require("QLibin\\models\\Price")

local MA = Class(Base)

function MA:init(settings)
    self.Super:init(settings)
    self.price = Price({})
end

function MA:calc(index)
    local sum = 0
    local period = self.settings.period
    for i = 0, period - 1 do
        local price = self.price(index - i)
        if price == nil then
            return nil
        end
        sum = sum + price
    end
    return sum / period
end

return MA
