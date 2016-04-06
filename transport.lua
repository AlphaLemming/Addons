local WM = WINDOW_MANAGER
local cs_tt = CraftStore:TOOLTIP()
local _,_,maxtrait = GetSmithingResearchLineInfo(CRAFTING_TYPE_BLACKSMITHING,1)

local function ToChat(text) StartChatInput(CHAT_SYSTEM.textEntry:GetText()..text) end

local function SetResearch(craft,line,trait)
end

local function PostTrait(craft,line,trait)
end

local function DrawColumn(craft,line,parent)
	local name, icon = GetSmithingResearchLineInfo(craft,line)
	local craftname = GetSkillLineInfo(GetCraftingSkillLineIndices(craft))
	local c = WM:CreateControl('$(parent)Line'..line, parent, CT_BUTTON)
	c:SetAnchor(3,parent,3,(line-1)*26,0)
	c:SetDimensions(29,maxtrait*26+63)
	c:SetNormalTexture('CraftStore4/dds/grey.dds')
	c:SetMouseOverTexture('CraftStore4/dds/over.dds')
	local x = WM:CreateControl('$(parent)Texture', c, CT_TEXTURE)
	x:SetAnchor(1,c,1,0,2)
	x:SetDimensions(27,27)
	x:SetTexture(icon)
	for trait = 1, maxtrait do
		local t = WM:CreateControl('$(parent)Trait'..trait, c, CT_BUTTON)
		t:SetAnchor(3,c,3,2,33+(trait-1)*26)
		t:SetDimensions(25,25)
		t:SetMouseOverTexture('CraftStore4/dds/over.dds')
		t:SetClickSound('Click')
		t:SetEnableMouseButton(2,true)
		t:SetHandler('OnMouseEnter', function(self) cs_tt:ShowTooltip(self) end)
		t:SetHandler('OnMouseExit', function(self) cs_tt:HideTooltip(self) end)
		t:SetHandler('OnMouseDown', function(self,button) if button == 1 then SetResearch(craft,line,trait) else PostTrait(craft,line,trait) end end)
	end
	local l = WM:CreateControl('$(parent)Count', c, CT_BUTTON)
	l:SetAnchor(4,c,4,0,-2)
	l:SetDimensions(25,25)
	l:SetHorizontalAlign(1)
	l:SetVerticalAlign(1)
	l:SetFont('CS4Font')
	l:SetNormalFontColor(1,1,1,1)
	l:SetNormalTexture('CraftStore4/dds/dark.dds')
	local b = WM:CreateControl('$(parent)Blend', c, CT_BUTTON)
	b:SetAnchor(3,c,3,0,32)
	b:SetDimensions(29,maxtrait*26+31)
	b:SetNormalTexture('CraftStore4/dds/grey.dds')
	b:SetMouseOverTexture('CraftStore4/dds/over.dds')
	b:SetHidden(true)
	local x = WM:CreateControl('$(parent)Texture', b, CT_TEXTURE)
	x:SetAnchor(128,b,128,0,0)
	x:SetDimensions(27,27)
	x:SetTexture('CraftStore4/dds/disabled.dds')
end

local function DrawTraitRow(line,trait,nr,y)
	local tr = WM:CreateControl('CS4_Armor_TraitRow'..nr, CS4_Panel, CT_BUTTON)
	local _,desc = GetSmithingResearchLineTraitInfo(CRAFTING_TYPE_BLACKSMITHING,line,trait)
	local _,name,icon = GetSmithingTraitItemInfo(trait + 1)
	tr:SetAnchor(3,CS4_Panel,6,10,y+(nr-1)*26)
	tr:SetDimensions(153,25)
	tr:SetText(zo_strformat('<<C:1>>',name)..' |t25:25:'..icon..'|t ')
	tr:SetHorizontalAlign(2)
	tr:SetVerticalAlign(1)
	tr:SetFont('CS4Font')
	tr:SetNormalFontColor(1,1,1,1)
	tr:SetMouseOverFontColor(1,0.66,0.2,1)
	tr:SetNormalTexture('CraftStore4/dds/grey.dds')
	tr:SetHandler('OnMouseEnter',cs_tt:ShowTooltip())
	tr:SetHandler('OnMouseExit',cs_tt:HideTooltip())
	tr.cs_data = { info = desc }
end

function self:DrawMatrix()
	local craft
	local cs_trait = CraftStore:TRAIT()

	for trait,nr in pairs(cs_trait:GetArmorTraits()) do DrawTraitRow(8,trait,nr,69) end
	for trait,nr in pairs(cs_trait:GetWeaponTraits()) do DrawTraitRow(1,trait,nr,369) end

	craft = CRAFTING_TYPE_CLOTHIER
	
	local c1 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
	c1:SetAnchor(3,CS4_Armor_TraitRow1,9,1,-32)
	c1:SetResizeToFitDescendents(true)
	for line = 1, 7 do DrawColumn(craft,line,c1) end

	local c2 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
	c2:SetAnchor(3,c1,9,5,0)
	c2:SetResizeToFitDescendents(true)
	for line = 8, 14 do DrawColumn(craft,line,c2) end
	
	craft = CRAFTING_TYPE_BLACKSMITHING
	
	local c3 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
	c3:SetAnchor(3,c2,9,5,0)
	c3:SetResizeToFitDescendents(true)
	for line = 8, 14 do DrawColumn(craft,line,c3) end

	local c4 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
	c4:SetAnchor(3,CS4_Weapon_TraitRow1,9,5,-32)
	c4:SetResizeToFitDescendents(true)
	for line = 1, 7 do DrawColumn(craft,line,c4) end
	
	craft = CRAFTING_TYPE_WOODWORKING
	
	local c5 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
	c5:SetAnchor(3,c3,9,5,0)
	c5:SetResizeToFitDescendents(true)
	DrawColumn(craft,6,c5) end

	local c6 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
	c6:SetAnchor(3,c4,9,5,0)
	c6:SetResizeToFitDescendents(true)
	for line = 1, 5 do DrawColumn(craft,line,c6) end
end
