local utils = require("QLibin\\utils")
local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")
local Price = require("QLibin\\models\\Price")

local EMA = Class(Base)

function EMA:init(settings)
    self.Super:init(settings)
    self.price = Price({hloc='C'})
end

function EMA:calc(index)
    local period = self.settings.period
    if type(period) ~= "number" or period < 1 then
        utils.log('ERROR: Wrong period. It should be at least 1.')
        return nil
    end

    local curPrice = self.price(index)
    if curPrice == nil then return nil end

    local prevEMA = self(index - 1)
    if prevEMA == nil then return curPrice end

    local smoothFactor = 2 / (1 + period)
    return smoothFactor * curPrice + (1 - smoothFactor) * prevEMA
end

return EMA