local utils = require("LuaIndicators\\utils")
local Class = require("LuaIndicators\\oop")
local Base = require("LuaIndicators\\indicators\\base")
local QSettings = dofile("LuaIndicators\\settings") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings


Settings = QSettings({
Name = "*MA = Moving Average",
line = {
    {
        Name = "MA line",
        Type = TYPE_LINE,
        Color = RGB(180, 170, 160)
        },
    },
period = 5
})


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

function MA:init(settings, price_src)
    self.Super:init(settings)
    self.price = price_src
end

function MA:calc(index)
    local sum = 0
    local period = self.settings.period
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
    indicator = MA(QSettings, priceSrc)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end
