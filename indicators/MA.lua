local utils = require("LuaIndicators\\indicators\\utils")

Settings = { -- todo: create a fabric
Name = "*MA = Moving Average",
line = {
    {
        Name = "MA line",
        Type = TYPE_LINE,
        Color = RGB(180, 170, 160)
        },
    },
period = 5
}

local indicator

function Init()
    indicator = MA:new(priceSrc, Settings)
    return #Settings.line
end

function OnCalculate(Index)
    return indicator(Index)
end


local function getSetting(name)
    return Settings[name]
end

priceSrc = setmetatable(
    {},
    {__index = function(tbl, index)
            if index > 0 then
                return C(index)
            else
                return nil
            end
        end
    })



MA = {
    values = setmetatable({}, {__mode = 'v'}),
}


function MA:new(price_src)
    local newObj = {}
    newObj.value = nil
    newObj.price = price_src
    self.__index = self
    return setmetatable(newObj, self)
end

function MA:__call(index)
    self.values[index] = self:calc(index)  -- todo: "= self.values[index] or " with settings changing
    return self.values[index]
end

function MA:calc(index)
    local sum = 0
    local period = getSetting('period')
    utils.log({index, period, Settings.period})
    for i = 0, period - 1 do
        local price = self.price[index - i]
        if price == nil then
            return nil
        end
        sum = sum + price
    end
    return sum / period
end
