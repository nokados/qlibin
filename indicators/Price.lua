local utils = require("LuaIndicators\\indicators\\utils")

Settings = { -- todo: create a fabric
Name = "*Price",
line = {
	{
		Name = "Price line",
		Type = TYPE_LINE,
		Color = RGB(140, 140, 140)
		},
	},
}

local price

function Init()
	price = Price:new()
	return #Settings.line
end

function OnCalculate(Index)
	return price:tick(Index)
end



Price = {}

function Price:new()
	local newObj = {
		high = nil,
		low = nil,
		open = nil,
		close = nil,
		output = 1,
	}
	self.__index = self
	self.value = nil
	return setmetatable(newObj, self)
end

function Price:tick(index)
	self.index = index
	self:update()
	self:draw()
	return self.value
end

function Price:update()
	local index = self.index
	self.high = H(index)
	self.low = L(index)
	self.open = O(index)
	self.close = C(index)
end

function Price:draw()
	utils.log({'Draw', self.index, self.output, self.high})
	self.value = self.high
	-- SetValue(self.index, self.output, self.high)
end
