local FractalsUp, FractalsDown = unpack(require("QLibin\\models\\Fractals"))
local QSettings = dofile("QLibin\\settings.lua") -- dofile чтобы
    -- разные индикаторы имели разный экземпляр QSettings

Settings = QSettings({
Name = "*Fractals",
Period = 5,
line = {
		{
		Name = "FRACTALS - Up",
		Type = TYPE_TRIANGLE_UP,
		Color = RGB(0, 206, 0)
		},
		{
		Name = "FRACTALS - Down",
		Type = TYPE_TRIANGLE_DOWN,
		Color = RGB(221, 44, 44)
		}
		},
})

local frUp, frDown

function Init()
    frUp = FractalsUp(QSettings)
    frDown = FractalsDown(QSettings)
    return #Settings.line
end

function OnCalculate(Index)
    return frUp(Index), frDown(Index)
end
