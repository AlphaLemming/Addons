local FilterType = {}

function CraftStore:TOOLS()
	self = {}

	function self:spairs(t)
		local keys, i = {}, 0
		for k in pairs(t) do keys[#keys+1] = k end
		table.sort(keys,function(a,b) return a<b end)
		return function()
			i = i + 1
			if keys[i] then return keys[i], t[keys[i]] end
		end
	end

	function self:CreateFilterList()
		for nr = 1,ITEMTYPE_MAX_VALUE do table.insert(FilterType,{nr,GetString('SI_ITEMTYPE',nr)}) end
		table.sort(FilterType,function(a,b) return a[2] < b[2] end)
	end
	
	function StockSort()
		local sorted, name, stack = {}
		local filter, owner = CraftStore.account.bagFilter, CraftStore.account.sourceFilter
		for k,data in pairs(CraftStore.account.stock) do
			local found, phrase = false, CS4_BagsSortingPhrase:GetText()
			name = zo_strformat('<<C:1>>',GetItemLinkName(data.link))
			stack = data[owner] or self:TabCount(data)
			if phrase ~= '' and string.find(name,phrase) then found = true end
			if owner and data[owner] then found = true end
			if filter and GetItemLinkItemType(data.link) == filter then found = true end
			if phrase == '' and not owner and not filter then found = true end
			if found then table.insert(sorted,{name,k,stack}) end
		end
		table.sort(sorted,function(a,b) return a[1] < b[1] end)
		return sorted
	end
	
	function self:FlatLink(link)
		local split = {SplitString(':', link)}
		split[22] = 10000
		return table.concat(split,':')
	end

	function self:SplitLink(link,nr)
		local split = {SplitString(':', link)}
		if split[nr] then return tonumber(split[nr]) else return false end
	end

	function self:CompareItem(link1,link2)
		if not link2 then return true end
		if GetItemLinkQuality(link1) < GetItemLinkQuality(link2) then return true end
		if GetItemLinkQuality(link1) > GetItemLinkQuality(link2) then return false end
		if GetItemLinkRequiredLevel(link1) < GetItemLinkRequiredLevel(link2) then return true end
		if GetItemLinkRequiredVeteranRank(link1) < GetItemLinkRequiredVeteranRank(link2) then return true end
		return false
	end

	function self:SetPoint(val)
		while true do  
			val, k = string.gsub(val,'^(-?%d+)(%d%d%d)','%1.%2')
			if k == 0 then return val end
		end
	end

	function self:GetTime(seconds)
		if seconds and seconds > 0 then
			local d = math.floor(seconds / 86400)
			local h = math.floor((seconds - d * 86400) / 3600)
			local m = math.floor((seconds - d * 86400 - h * 3600) / 60)
			local s = math.floor((seconds - d * 86400 - h * 3600 - m * 60))
			if d > 0 then return ('%ud %02u:%02u:%02u'):format(d,h,m,s)
			elseif h > 0 return ('%02u:%02u:%02u'):format(h,m,s) end
			else return ('%02u:%02u'):format(m,s) end
		else return '|t16:16:CraftStore4/tick.dds|t' end
	end

	function self:GetCharacters()
		local oi = {}
		for key,_ in pairs(CraftStore.account.player) do table.insert(oi,key) end
		table.sort(oi)
		return oi
	end

	function self:GetBonus(bonus,craft)
		local level = GetNonCombatBonus(bonus) or 1
		local _,rank = GetSkillLineInfo(GetCraftingSkillLineIndices(craft))
		return {rank, level, GetMaxSimultaneousSmithingResearch(craft) or 1}
	end

	function self:GetLineInfo(craft,line)
		local name, icon = GetSmithingResearchLineInfo(craft,line)
		local craftname = GetSkillLineInfo(GetCraftingSkillLineIndices(craft))
		return zo_strformat('<<C:1>>',craftname), zo_strformat('<<C:1>>',name), icon
	end

	function self:GetTraitInfo(craft,line,trait)
		local tid,desc = GetSmithingResearchLineTraitInfo(craft,line,trait)
		local _,name,icon = GetSmithingTraitItemInfo(tid + 1)
		return zo_strformat('<<C:1>>',name), GetString('SI_ITEMTRAITTYPE',tid), desc, icon
	end

	function self:ToChat(text) StartChatInput(CHAT_SYSTEM.textEntry:GetText()..text) end
	
	return self
end
