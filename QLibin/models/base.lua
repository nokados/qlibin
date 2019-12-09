local Class = require("QLibin\\oop")

local value_meta = {is_value_meta = true} -- Metatable для значений, которые хранит индикатор.
-- Используется, чтобы отличать запакованные значения от сырых (сырые тоже могут быть таблицей)
local function Value(val)
    return setmetatable(val, value_meta)
end

local function isPackedValue(val)
    local val_mtb = getmetatable(val)
    return val_mtb and val_mtb.is_value_meta
end

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
    @tparam int|table out Индекс линии на графике, которая отображает значения этого индикатора.
                          Может быть несколько индексов. Тогда они передаются в таблице: напр. {1,2,4}
--]]

function Base:init(settings, out)
    self.out = out or 1
    if type(self.out) ~= 'table' then
        self.out = {self.out}
    end
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
        self:set(index, Value({self:calc(index)}))
    end
    return self:get(index)
end

function Base:isSet(index)
    return self.values[index] ~= nil
end

function Base:get(index)
    return unpack(self.values[index])
end

function Base:set(index, value) -- что если value таблица, но не упакованная, а объект?
    if not isPackedValue(value) then
        value = Value({value})
    end
    self.values[index] = value
end

function Base:setAndDraw(index, value)
    if not isPackedValue(value) then
        value = Value({value})
    end
    self:set(index, value)
    for i = 1, #value do -- лень проверить длину self.out тоже
        SetValue(index, self.out[i], value[i])
    end
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
