-- implementation from https://habr.com/ru/post/346892/
local function Class(parent)
  local class = {}
    local mClass = {}

    -- Сам класс будет метатаблицей для объектов.
    -- Это позволит дописывать ему метаметоды.
    class.__index = class

    -- Поля объектов будут искаться по цепочке __index,
    -- и дотянутся, в том числе, до родительского класса.
    mClass.__index = parent

    -- Резервируем поле Super под родителя.
    class.Super    = parent


    -- Функция, которая будет вызываться при вызове класса
    function mClass:__call(...)
        local instance = setmetatable({}, class)

        -- Резервируем поле класса "init"
        if type(class.init) == 'function' then
            instance:init(...)
            -- Возвращаем экземпляр
            return instance
        end

        -- Но если её нет - тоже ничего.
        return instance
    end

    return setmetatable(class, mClass)
end

return Class