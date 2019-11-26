local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")
local utils = require("QLibin\\utils")


local Candles = Class(Base)
local OneCandle = Class(Base)

function OneCandle:init(h, l, o, c)
    self.high = h
    self.low = l
    self.open = o
    self.close = c
end

function OneCandle:isGreen()
    return self.open < self.close
end

function OneCandle:isRed()
    return self.open > self.close
end

function Candles:calc(index)
    if index > 0 then
        local h, l, o, c = H(index), L(index), O(index), C(index)
        if utils.anyNil(h,l,o,c) then
            return nil
        end
        return OneCandle(h, l, o, c)
    else
        return nil
    end
end

return Candles
