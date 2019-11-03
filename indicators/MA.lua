local utils = require("LuaIndicators\\utils")
local Class = require("LuaIndicators\\oop")
local Base = require("LuaIndicators\\indicators\\base")


Settings = { -- @todo: create a fabric
Name = "*MA = Moving Average",
line = {
    {
        Name = "MA line",
        Type = TYPE_LINE,
        Color = RGB(180, 170, 160)
        },
    },
period = 5
}


local function getSetting(name)
    return Settings[name]
end

local priceSrc = setmetatable(
    {},
    {__index = function(tbl, index)
            if index > 0 then
                return C(index)
            else
                return nil
            end
        end
    })



local MA = Class(Base)


function MA:init(price_src)
    self.Super:init()
    self.price = price_src
end

function MA:calc(index)
    local sum = 0
    local period = getSetting('period')
    utils.log({index, period, Settings.period})
    for i = 0, period - 1 do
        local price = self.price[index - i]
        if price == nil then
            return nil
        end
        sum = sum + price
    end
    return sum / period
end

local indicator

function Init()
    indicator = MA(priceSrc, Settings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end
