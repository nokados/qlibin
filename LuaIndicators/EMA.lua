local EMA = require("QLibin\\models\\EMA")
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings



Settings = QSettings({
Name = "*EMA = Exponential Moving Average",
line = {
    {
        Name = "MA line",
        Type = TYPE_LINE,
        Color = RGB(60, 170, 60)
        },
    },
period = 12
})

local indicator

function Init()
    indicator = EMA(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end
