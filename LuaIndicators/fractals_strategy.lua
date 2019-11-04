Settings = {
Name = "*FRACTALS STRATEGY (FracStrat)",
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE,
		Color = RGB(50, 50, 240)
		},
		},
fractalsId = 'fractals2'
}


function Init()
	PrintDbgStr(package.path)
	return #Settings.line
end

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function empty(T)
	-- luacheck:ignore
	for _ in pairs(T) do
		return false
	end
	return true
end

local function drawLine(indexStart, valStart, indexFinish, valFinish)
	local stepReduce = (valFinish - valStart) / (indexFinish - indexStart)
	for i = indexStart, indexFinish do
		local stepId = i - indexStart
		SetValue(i, 1, valStart + stepId * stepReduce)
	end
	SetValue(indexFinish, 1, valFinish)
end

local valId = nil
local val = nil
local function update(index)
	if index <= 1 then val = nil end -- starting with start
	local priceUp, _, _ = getCandlesByIndex(Settings.fractalsId, 1, index-1, 1)
	if empty(priceUp) then
		val = nil
		return nil
	end
	local el = priceUp[0]
	if el.doesExist == 1 then
		if val ~= nil then
			drawLine(valId, val, index, el.high)
		end
		val = el.high
		valId = index
	end
end

function OnCalculate(index)
	if not pcall(update, index) then
		PrintDbgStr('Error during OnCalculate. index == '..dump(index))
	end
	return nil
end
