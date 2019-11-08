local utils = require("QLibin\\utils")
local Class = require("QLibin\\oop")
local Base = require("QLibin\\models\\base")
local Price = require("QLibin\\models\\Price")

-------------------
-- Base Fractals --
-------------------
local Fractals = Class(Base)

function Fractals:calc(index)
    local midIndex = index - 2 -- remember: it may be < 0
    local pos
    if self:isFractal(midIndex) then
        pos = self.price(midIndex)
        self:set(midIndex, pos)
    end
    return nil
end

--- значения цен для индексов в диапазоне от begin до end_, включая оба
function Fractals:getPriceRange(begin, end_)
    local values = {}
    local newPos = 1
    for i = begin, end_ do
        values[newPos] = self.price(i)
        newPos = newPos + 1
    end
    return unpack(values)
end


-----------------  / m \
-- UP Fractals -- /l1 r1\
-----------------/l2   r2\
local FractalsUp = Class(Fractals)

function FractalsUp:init(settings, out)
    out = out or 1
    self.Super.init(self, settings, out) -- self передаем явно, иначе out будет общий с FractalsDown
    self.price = Price({hloc='H'})
end

function FractalsUp:isFractal(index)
    local l2, l1, m, r1, r2 = self:getPriceRange(index - 2, index + 2)
    if utils.anyNil(l2, l1, m, r1, r2) then return false end
    if l2 > m or l1 > m then
        return false
    end
    if r2 > m or r1 > m then
        return false
    end
    return true
end

-------------------\l2   r2/
-- DOWN Fractals -- \l1 r1/
-------------------  \ m /
local FractalsDown = Class(Fractals)

function FractalsDown:init(settings, out)
    out = out or 2
    self.Super.init(self, settings, out) -- self передаем явно, иначе out будет общий с FractalsUp
    self.price = Price({hloc='L'})
end

function FractalsDown:isFractal(index)
    local l2, l1, m, r1, r2 = self:getPriceRange(index - 2, index + 2)
    if utils.anyNil(l2, l1, m, r1, r2) then return false end
    if l2 < m or l1 < m then
        return false
    end
    if r2 < m or r1 < m then
        return false
    end
    return true
end

return {FractalsUp, FractalsDown}
