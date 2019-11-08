local MA = require("QLibin\\models\\MA")
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
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

local indicator

function Init()
    indicator = MA(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end
