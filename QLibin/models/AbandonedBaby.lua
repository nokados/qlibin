local utils = require("QLibin\\utils")
local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")
local Candles = require("QLibin\\models\\Candles")

-------------------
-- Base ABaby --
-------------------
local ABaby = Class(Base)

function ABaby:init(settings, out)
    ABaby.Super.init(self, settings, out)
     -- we use ABaby instead self above, because self may be an instance of child class => infinite loop
    self.candles = Candles() -- Maybe I should get it from arguments...
end

function ABaby:calc(index)
    local left = self.candles(index - 2)
    local mid = self.candles(index - 1)
    local right = self.candles(index)

    local minLow, maxHigh = nil, nil -- отображение индикатора свечами
    if self:isAbandonedBaby(left, mid, right) then
        -- Drawing
        minLow = math.min(left.low, mid.low, right.low)
        maxHigh = math.max(left.high, mid.high, right.high)
        self:setAndDraw(index - 2, {minLow, maxHigh}) -- set for index - 2
        self:setAndDraw(index - 1, {minLow, maxHigh}) -- set for index - 1
    end
    return maxHigh, minLow -- set for index
end


----------------
--- UP ABaby ---
----------------
local ABabyUp = Class(ABaby)

function ABabyUp:init(settings, out)
    out = out or {1, 2}
    ABabyUp.Super.init(self, settings, out) -- self передаем явно, иначе out будет общий с ABabyDown
end

function ABabyUp:isAbandonedBaby(left, mid, right)
    if utils.anyNil(left, mid, right) then return false end -- все 3 должны присутствовать
    return left:isGreen() and -- первая зеленая (прозрачная)
           mid.open > left.close and -- гэп по тренду вверх
           mid.close > left.close and -- и не закрывается
           right.open < mid.close -- 3-я свеча открывается гэп в противоположную сторону
end

----------------
-- DOWN ABaby --
----------------
local ABabyDown = Class(ABaby)

function ABabyDown:init(settings, out)
    out = out or {3, 4}
    ABabyDown.Super.init(self, settings, out) -- self передаем явно, иначе out будет общий с ABabyUp
end

function ABabyDown:isAbandonedBaby(left, mid, right)
    if utils.anyNil(left, mid, right) then return false end -- все 3 должны присутствовать
    return left:isRed() and -- первая красная (закрашенная)
           mid.open < left.close and -- гэп по тренду вниз
           mid.close < left.close and -- и не закрывается
           right.open > mid.close -- 3-я свеча открывается гэп в противоположную сторону
end

return {ABabyUp, ABabyDown}
