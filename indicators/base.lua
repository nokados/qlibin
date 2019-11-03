local Class = require("LuaIndicators\\oop")

local Base = Class()

--[[ init запускается при создание класса. Здесь инициализируем values.
    Наследники Base должны обязательно вызывать эту функцию в своем init:
        `self.Super:init()`
    values - Таблица со значениями индикатора в формате
        Индекс свечи => значение
    Мы задаем ей `__mode = 'v'`, что означает, что она будет действовать как кэш:
        Если на значения values больше нет ссылок, то элементы в таблице могут быть
        автоматически удалены при сборке мусора. Это позволяет автоматически
        очищать память, при этом почти не пересчитывая значения заново.
--]]
function Base:init()
    self.values = setmetatable({}, {__mode = 'v'})
end


--[[ Позволяет вызывать объекты класса как функции.
    Результат работы функции этой функции - значение индикатора на заданном индексе.
    Значение либо берется из таблицы values, либо вычисляется методом `self:calc(index)`
    Если значение вычислялось методом `calc`, то результат сохраняется в кэше - self.values
    @tparam int index индекс свечи, для которой хотим узнать значение индикатора
    @treturn nil|number значение индикатора в позиции index
--]]
function Base:__call(index)
    self.values[index] = self:calc(index)  -- @todo: "= self.values[index] or " with settings changing
    return self.values[index]
end

--[[
    Вычисляет значение индикатора для свечи index.
    @tparam int index индекс свечи, для которой расчитываем значение индикатора
    @treturn nil|number вычисленное значение индикатора в позиции index
--]]
-- luacheck:ignore
function Base:calc(index)
    return nil
end

return Base
