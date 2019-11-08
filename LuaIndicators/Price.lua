local Price = require("QLibin\\models\\Price")
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings


Settings = QSettings({
Name = "*Price",
line = {
    {
        Name = "Price line",
        Type = TYPE_LINE,
        Color = RGB(180, 170, 160)
        },
    },
hloc = 'C'
})

local indicator

function Init()
    indicator = Price(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end
