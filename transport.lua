local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}
local xpos, ypos = 0, 0
for _,craft in pairs(crafting) do
	for line = 1, GetNumSmithingResearchLines(craft) do
		local craftname, name, icon = TOOLS:GetLineInfo(craft,line)
		local c = WM:CreateControl('$(parent)Icon'..craft..'&'..line,CS4_SetCraftTraitinfo,CT_BUTTON)
		c:SetAnchor(3,CS4_SetCraftTraitinfo,3,xpos,ypos)
		c:SetDimensions(32,32)
		c:SetNormalTexture('CraftStore4/grey.dds')
		c:SetMouseOverTexture('CraftStore4/over.dds')
		c.cs_data = { info = '|cFFFFFF'..craftname..'|r\n'..name..' ('..self.cs_data.traits..')', anchor = {c,1,4,0,2}, traits = 0 }
		local t = WM:CreateControl('$(parent)Texture',c,CT_TEXTURE)
		t:SetAnchor(128,c,128,0,0)
		t:SetDimensions(28,28)
		t:SetTexture(icon)
		xpos = xpos + 33
		if xpos == 231 then xpos = 0; ypos = ypos + 33 end
	end
end

function UpdateSet(nr)
	for _,craft in pairs(crafting) do
		for line = 1, GetNumSmithingResearchLines(craft) do
			local c = WM:GetControlByName('CS4_SetCraftTraitinfoIcon'..craft..'&'..line)
			local t, count = c:GetNamedChild('Texture'), GetTraitCount(craft,line)
			if count >= CraftStore.sets[nr].traits then t:SetColor(1,1,1,1) else t:SetColor(1,0,0,1) end
			c.cs_data.traits = count..' / '..CraftStore.sets[nr].traits
		end
	end
	CS4_SetCraftHeader:SetText(CraftStore.sets[nr].item)
end
