local utils = require("LuaIndicators\\utils")
local Class = require("LuaIndicators\\oop")
local Base = require("LuaIndicators\\indicators\\base")
local QSettings = dofile("LuaIndicators\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings


Settings = QSettings({ -- todo: create a fabric
Name = "*Price",
line = {
	{
		Name = "Price line",
		Type = TYPE_LINE,
		Color = RGB(140, 140, 140)
		},
	},
})


local Price = Class(Base)

function Price:calc(index)
	if index > 0 then
        return C(index)
    else
        return nil
    end
end

local indicator

function Init()
    indicator = Price(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end

return Price