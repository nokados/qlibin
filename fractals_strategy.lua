Settings = {
Name = "*FRACTALS STRATEGY (FracStrat)", 
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(50, 50, 240)
		},
		},
}

lines = {}
out = {}
fractalsId = 'fractals2'

function Init()
	return #Settings.line
end

valId = nil
val = nil
function OnCalculate(index)
	local priceUp, numLinesUp, nameUp = getCandlesByIndex(fractalsId, 1, index-1, 1)
	if empty(priceUp) then
		val = nil
		return nil
	end
	el = priceUp[0]
	if el.doesExist == 1 then
		if val ~= nil then
			drawLine(valId, val, index, el.high)
		end
		val = el.high
		valId = index
	end
	return nil
end

function drawLine(indexStart, valStart, indexFinish, valFinish)
	local stepReduce = (valFinish - valStart) / (indexFinish - indexStart)
	for i = indexStart, indexFinish do
		local stepId = i - indexStart
		SetValue(i, 1, valStart + stepId * stepReduce)
	end
end

function dump(o)
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

function empty(T)
  for _ in pairs(T) do return false end
  return true
end