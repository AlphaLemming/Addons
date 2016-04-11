function GetLineInfo(craft,line)
	local name, icon = GetSmithingResearchLineInfo(craft,line)
	local craftname = GetSkillLineInfo(GetCraftingSkillLineIndices(craft))
	return craftname, zo_strformat('<<C:1>>',name), icon
end

function GetTraitInfo(craft,line,trait)
	local tid,desc = GetSmithingResearchLineTraitInfo(craft,line,trait)
	local _,_,icon = GetSmithingTraitItemInfo(trait + 1)
	return GetString('SI_ITEMTRAITTYPE',tid), desc, icon
end

local function ShowLine(craft,line,trait)
	local block
	if trait > maxtrait then block = {1,2,3,4} else block = {5,6} end
	for _,x in pairs(block) do
		local c = WM:GetControlByName('CS4_ResearchBlock'..x)
		for z = 1, GetNumChildren(c) do
			c:GetChild(z):GetChild(trait):IsHandlerSet('OnMouseEnter',true)
		end
	end
end

tt = {
	trait = '|cFFFFFF<<1>>|r\n\n<<2>>',
	line = '|cFFFFFF<<1>>|r\n\n|t24:24:<<2>>|t <<3>>\n'..lmb..' <<4>>\n'..rmb..' <<5>>'
}

traititems = {
[CRAFTING_TYPE_CLOTHIER] = {45032,45033,45034,45035,45036,45038,45039,45041,45042,45043,45044,45045,45046,45047},
[CRAFTING_TYPE_BLACKSMITHING] = {45018,45019,45020,45021,45022,45023,45024,45025,45026,45027,45028,45029,45030,45031},
[CRAFTING_TYPE_WOODWORKING] = {45040,45049,45050,45051,45052,45048}}
