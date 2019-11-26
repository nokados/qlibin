local FractalsUp, FractalsDown = unpack(require("QLibin\\models\\AbandonedBaby"))
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings

Settings = QSettings({
Name = "*ABaby = AbandonedBaby",
line = {
        {
        Name = "Top of Thrown Up",
        Type = TYPE_CANDLE,
        Color = RGB(123, 179, 134),
        Width = 2
        },
        {
        Name = "Bottom of Thrown Up",
        Type = TYPE_CANDLE,
        Color = RGB(123, 179, 134),
        Width = 2
        },
        {
        Name = "Top of Thrown Down",
        Type = TYPE_CANDLE,
        Color = RGB(211, 100, 91),
        Width = 2
        },
        {
        Name = "Bottom of Thrown Down",
        Type = TYPE_CANDLE,
        Color = RGB(211, 100, 91),
        Width = 2
        }
        },
})

local abUp, abDown

function Init()
    abUp = FractalsUp(QSettings)
    abDown = FractalsDown(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    local topUp, btmUp = abUp(Index)
    local topDown, btmDown = abDown(Index)
    return topUp, btmUp, topDown, btmDown
end
