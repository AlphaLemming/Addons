	function self:vpairs(t)
		local vals, i = {}, 0
		for k in pairs(t) do
			local _,_,_,_,rawStyle = GetSmithingStyleItemInfo(k)
			local name = zo_strformat('<<C:1>>',GetString('SI_ITEMSTYLE', rawStyle))
			vals[#vals+1] = {k,name}
		end
		table.sort(vals,function(a,b) return a[2] < b[2] end)
		return function()
			i = i + 1
			if vals[i] then return vals[i][1], vals[i][2] end
		end
	end
