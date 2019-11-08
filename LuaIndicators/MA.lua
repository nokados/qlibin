local utils = require("QLibin\\utils")
local Class = require("QLibin\\oop")
local Base = require("LuaIndicators\\base")
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings
local Price = require("LuaIndicators\\Price")



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


local priceSrc = Price({})


local MA = Class(Base)

function MA:init(settings, priceSrc)
    self.Super:init(settings)
    self.price = priceSrc
end

function MA:calc(index)
    local sum = 0
    local period = self.settings.period
    utils.log({index, period, Settings.period})
    for i = 0, period - 1 do
        local price = self.price(index - i)
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
