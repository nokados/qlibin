local Class = require("QLibin\\oop")

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
    @tparam QSettings settings Обертка над настройками. Служит для получения актуальных настроек.
    @tparam int out Индекс линии на графике, которая отображает значения этого индикатора
--]]

function Base:init(settings, out)
    self.out = out or 1
    self.values = setmetatable({}, {__mode = 'v'})

    self.settings = settings
end

function Base:reinit()
    self:init(self.settings, self.out)
end
--[[ Позволяет вызывать объекты класса как функции.
    Результат работы функции этой функции - значение индикатора на заданном индексе.
    Значение либо берется из таблицы values, либо вычисляется методом `self:calc(index)`
    Если значение вычислялось методом `calc`, то результат сохраняется в кэше - self.values
    @tparam int index индекс свечи, для которой хотим узнать значение индикатора
    @treturn nil|number значение индикатора в позиции index
--]]
function Base:__call(index)
    if index == 1 then self:reinit() end
    if self:isSet(index) then
        return self:get(index)
    else
        self:set(index, self:calc(index))
    end
    return self:get(index)
end

function Base:isSet(index)
    return self.values[index] ~= nil
end

function Base:get(index)
    return self.values[index] and self.values[index][1]
end

function Base:set(index, value)
    self.values[index] = {value}
end

function Base:setAndDraw(index, value)
    self:set(index, value)
    SetValue(index, self.out, value)
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
