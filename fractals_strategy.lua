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
function Init()
	local fractalsId = 'fractals2'
	local numFracCandles = getNumCandles(fractalsId)
	local priceUp, numLinesUp, nameUp = getCandlesByIndex(fractalsId, 1, 0, numFracCandles)
	PrintDbgStr('UP: got '..numFracCandles..'(='..numLinesUp..') from '..nameUp)
	PrintDbgStr(dump(priceUp))
	local priceDown, numLinesDown, nameDown = getCandlesByIndex(fractalsId, 2, 0, numFracCandles)
	PrintDbgStr('DOWN: got '..numFracCandles..'(='..numLinesDown..') from '..nameDown)
	PrintDbgStr(dump(priceDown))

    local b, e = nil, nil
	for i = 0, #priceUp - 1 do
		local el = priceUp[i]
		if el.doesExist == 1 then
			lines[#lines+1] = {i+1, el.high}
		end
	end

	local li = 2 -- line index
	for I = 1, numLinesUp do
		out[I] = nil
		if li <= #lines then
			if I >= lines[li-1][1] then
				out[I] = lines[li - 1][2] + ((lines[li][2] - lines[li - 1][2]) * (I - lines[li-1][1])) / (lines[li][1] - lines[li-1][1])
			end
			if lines[li][1] <= I then
				li = li + 1
			end
		end
	end

	return #Settings.line
end


function OnCalculate(Index)
	return out[Index]
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