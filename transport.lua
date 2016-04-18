style = {{CRAFTING_TYPE_CLOTHIER,1},{CRAFTING_TYPE_CLOTHIER,8},{CRAFTING_TYPE_BLACKSMITHING,8}},
	
	local function SetPlayerResearch(craft,data,known,unknown)
		local p, current, color, maxsim, level, rank, c, n = WM:GetControlByName('CS4_Research'..craft), 0, '|cFFFFFF'
		local pip = '|r|c808080 '..GetString(SI_BULLET)..'|r '
		for x = 1,3 do
			c = p:GetNamedChild('Line'..x)
			n = c:GetNamedChild('Name')
			if data[x] then
				c:GetNamedChild('Time'):SetText(TOOLS:GetTime(data[x][3]))
				n:SetText(data[x][1])
				n.cs_data = { info = data[x][2], anchor = {3,n,9,0,2} }
				current = current + 1
			else
				c:GetNamedChild('Time'):SetText('')					
				n:SetText('')
				n.cs_data = nil
			end
		end
		rank, level, maxsim = unpack(CraftStore.account.player[CHAR].crafting[craft])
		if maxsim > 1 then if current == maxsim then color = '|c00FF00' else color = '|cFF0000' end end
		p:GetNamedChild('Data'):SetText('|t25:25:'..CraftStore.crafticon[craft]..'|t |c00FF00'..known..pip..'|cFF0000'..unknown..pip..'|c808080'..LANG:Get('level')..': '..level..' ('..rank..')|r')
		p:GetNamedChild('Slot'):SetText(color..current..' / '..maxsim..'|r')
	end

	function self:GetPlayerResearch()
		local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}
		for _,craft in pairs(crafting) do
			local research, known, unknown = {}, 0, 0
			for line = 1, GetNumSmithingResearchLines(craft) do
				for trait = 1, maxtraits do
					local val = CraftStore.account.player[CHAR].research[craft][line][trait] or false
					if val == true then
						known = known + 1
					elseif val == false then
						unknown = unknown + 1
					elseif val > 0 then
						table.insert(research,{'|t23:23:'..icon..'|t '..name,desc,dur})
					end
					SetIcon(craft,line,trait)
				end
				SetCount(craft,line)
			end
			SetPlayerResearch(craft,research,known,unknown)
		end
	end
