AG4.name = 'AlphaGearX2'
AG4.version = '4.00'
AG4.init = false
AG4.account = {}
AG4.setdata = {}
local L, ZOSF = AG4[GetCVar('language.2')] or AG4.en, zo_strformat
local QUALITY = {[0]={0.65,0.65,0.65,1},[1]={1,1,1,1},[2]={0.17,0.77,0.05,1},[3]={0.22,0.57,1,1},[4]={0.62,0.18,0.96,1},[5]={0.80,0.66,0.10,1}}
local QUALITYHEX = {[0]='B3B3B3',[1]='FFFFFF',[2]='2DC50E',[3]='3A92FF',[4]='A02EF7',[5]='EECA2A'}
local MAXSLOT, MENU, SELECT, SELECTBAR, DRAGINFO, TTANI, SWAP = 16, { nr = nil, type = nil, copy = nil }, false, false, {}, false, false
local EM, WM, SM = EVENT_MANAGER, WINDOW_MANAGER, SCENE_MANAGER
local GEARQUEUE, SLOTS, DUPSLOTS = {}, {
{EQUIP_SLOT_MAIN_HAND,'mainhand','MainHand'},
{EQUIP_SLOT_OFF_HAND,'offhand','OffHand'},
{EQUIP_SLOT_BACKUP_MAIN,'mainhand','BackupMain'},
{EQUIP_SLOT_BACKUP_OFF,'offhand','BackupOff'},
{EQUIP_SLOT_HEAD,'head','Head'},
{EQUIP_SLOT_CHEST,'chest','Chest'},
{EQUIP_SLOT_LEGS,'legs','Leg'},
{EQUIP_SLOT_SHOULDERS,'shoulders','Shoulder'},
{EQUIP_SLOT_FEET,'feet','Foot'},
{EQUIP_SLOT_WAIST,'belt','Belt'},
{EQUIP_SLOT_HAND,'hands','Glove'},
{EQUIP_SLOT_NECK,'neck','Neck'},
{EQUIP_SLOT_RING1,'ring','Ring1'},
{EQUIP_SLOT_RING2,'ring','Ring2'}},
{1,2,3,4,13,14}

local function GetColor(val)
	local r,g = 0,0
	if val >= 50 then r = 100-((val-50)*2); g = 100 else r = 100; g = val*2 end
	return r/100, g/100, 0
end

function AG4.DrawMenu(c,line)
	AG_PanelMenu:ToggleHidden()
	AG_PanelMenu:SetAnchor(3,c,6,0,0)
	local h, c = 0
	for z,x in pairs(line) do
		c = AG_PanelMenu:GetChild(z)
		if x then
			h = h + 30
			c:SetHeight(30)
			c:SetHidden(false)
		else
			c:SetHeight(0)
			c:SetHidden(true)
		end
	end
	AG_PanelMenu:SetHeight(h + 20)
end
function AG4.DrawInventory()
	local tex = 'AlphaGearX2/spot.dds'
	for _,c in pairs(SLOTS) do
		local p = WM:GetControlByName('ZO_CharacterEquipmentSlots'..c[3])
		local s = WM:CreateControl('AG_InvBg'..c[1], p, CT_TEXTURE)
		s:SetHidden(true)
		s:SetDrawLevel(1)
		s:SetTexture('AlphaGearX2/hole.dds')
		s:SetColor(1,1,1,1)
		s:SetAnchorFill()
		s = p:GetNamedChild('DropCallout')
		s:ClearAnchors()
		s:SetAnchor(1,p,1,0,2)
		s:SetDimensions(52,52)
		s:SetTexture(tex)
		s:SetDrawLayer(0)
		s = p:GetNamedChild('Highlight')
		if s then
			s:ClearAnchors()
			s:SetAnchor(1,p,1,0,2)
			s:SetDimensions(52,52)
			s:SetTexture(tex)
		end
		s = WM:CreateControl('AG_InvBg'..c[1]..'Condition', p, CT_LABEL)
		s:SetFont('ZoFontGameSmall')
		s:SetAnchor(TOPRIGHT,p,TOPRIGHT,7,-2)
		s:SetDimensions(50,10)
		s:SetHidden(true)
		s:SetHorizontalAlignment(2)
	end
end
function AG4.DrawButton(p,name,btn,nr,x,xpos,ypos,show)
	local c = WM:CreateControl('AG_'..name..'_'..btn..'_'..nr..'_'..x, p, CT_BUTTON)
	c:SetAnchor(2,p,2,xpos,ypos)
	c:SetDrawTier(1)
	c:SetDimensions(40,40)
	c:SetMouseOverTexture('AlphaGearX2/light.dds')
	if not show then
		c:SetClickSound('Click')
		c:EnableMouseButton(2,true)
		c:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
		c:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
		c:SetHandler('OnReceiveDrag',function(self) AG4.OnDragReceive(self) end)
		if btn == 'Gear' then c:SetHandler('OnMouseDown',function(self,button) if button == 2 then AG4.setdata[nr].Gear[x] = { id = 0, link = 0 }; AG4.ShowButton(self) elseif button == 1 then AG4.LoadItem(nr,x) end end) end
		if btn == 'Skill' then c:SetHandler('OnMouseDown',function(self,button) if button == 2 then AG4.setdata[nr].Skill[x] = {0,0,0}; AG4.ShowButton(self) elseif button == 1 then AG4.LoadSkill(nr,x) end end) end
	end
	local b = WM:CreateControl('AG_'..name..'_'..btn..'_'..nr..'_'..x..'Bg', c, CT_BACKDROP)
	b:SetAnchor(128,c,128,0,0)
	b:SetDimensions(44,44)
	b:SetCenterColor(0,0,0,0.2)
	b:SetEdgeColor(0,0,0,0)
	b:SetEdgeTexture('',1,1,2)
	b:SetInsets(2,2,-2,-2)
	AG4.ShowButton(c)
end
function AG4.DrawButtonLine(mode,nr)
	local dim,count,btn,c,p,b = {635,299},{14,6},{'Gear','Skill'}
	if mode == 1 then p = WM:CreateControl('AG_Selector_Gear_'..nr, AG_PanelGearPanelScrollChild, CT_BUTTON)
	else p = WM:CreateControl('AG_Selector_Skill_'..nr, AG_PanelSkillPanelScrollChild, CT_BUTTON) end
	p:SetAnchor(3,nil,3,0,45*(nr-1))
	p:SetDimensions(dim[mode],44)
	p:SetClickSound('Click')
	p:EnableMouseButton(2,true)
	p:SetNormalTexture('AlphaGearX2/grey.dds')
	p:SetMouseOverTexture('AlphaGearX2/light.dds')
	p.data = { header = '|cFFAA33'..L.Head[btn]..nr..'|r', info = L.Selector[btn] }
	p:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	p:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	if mode == 1 then c:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 1),true,true}); MENU.nr = nr; MENU.type = mode
		elseif button == 1 then if SELECT then AG4.setdata[SELECT].Set.gear = nr; SELECT = false; AG4.UpdateUI(SELECT,SELECT) else AG4.LoadGear(nr) end end 
	end) end
	if mode == 2 then c:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 2),false,true}); MENU.nr = nr; MENU.type = mode
		elseif button == 1 then if SELECT then AG4.setdata[SELECT].Set.skill[SELECTBAR] = nr; SELECT = false; AG4.UpdateUI(SELECT,SELECT) else AG4.LoadBar(nr) end end 
	end) end
	c = WM:CreateControl('AG_Selector_'..btn[mode]..'_'..nr..'_Label', p, CT_LABEL)
	c:SetAnchor(3,p,3,0,0)
	c:SetDrawTier(1)
	c:SetDimensions(44,44)
	c:SetHorizontalAlignment(1)
	c:SetVerticalAlignment(1)
	c:SetFont('AGFontBold')
	c:SetColor(1,1,1,0.8)
	c:SetText(nr)
	for x = 1,count[mode] do AG4.DrawButton(p,'Button',btn[mode],nr,x,46+42*(x-1),0) end
end
--[[
function AG4.DrawSkillButton(nr)
	local c, s, l
	s = WM:CreateControl('AG_Selector_Skill_'..nr, AG_PanelSkillPanelScrollChild, CT_BUTTON)
	s:SetAnchor(3,nil,3,0,45*(nr-1))
	s:SetDimensions(299,44)
	s:SetClickSound('Click')
	s:EnableMouseButton(2,true)
	s:SetNormalTexture('AlphaGearX2/grey.dds')
	s:SetMouseOverTexture('AlphaGearX2/light.dds')
	s.data = { header = '|cFFAA33'..L.Head.Skill..nr..'|r', info = L.Selector.Skill }
	s:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	s:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	s:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then
			AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 2),false,true})
			MENU.nr = nr
			MENU.type = 2
		elseif button == 1 then
			if SELECT.on and SELECT.mode > 1 then
				AG4.setdata[SELECT.nr].Set.skill[SELECT.mode-1] = nr
				WM:GetControlByName('AG_SetButton_'..SELECT.nr..'_'..SELECT.mode):SetText(nr)
			else AG4.LoadBar(nr) end
		end
	end)
	l = WM:CreateControl('AG_Selector_Skill_'..nr..'_Label', s, CT_LABEL)
	l:SetAnchor(3,s,3,0,0)
	l:SetDrawTier(1)
	l:SetDimensions(44,44)
	l:SetHorizontalAlignment(1)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFontBold')
	l:SetColor(1,1,1,0.8)
	l:SetText(nr)
	for x = 1,6 do
		c = WM:CreateControl('AG_Button_Skill_'..nr..'_'..x, s, CT_BUTTON)
		c:SetAnchor(2,s,2,46+42*(x-1),0)
		c:SetDrawTier(1)
		c:SetDimensions(40,40)
		c:SetClickSound('Click')
		c:EnableMouseButton(2,true)
		c:SetMouseOverTexture('AlphaGearX2/light.dds')
		c:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
		c:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
		c:SetHandler('OnReceiveDrag',function(self) AG4.OnDragReceive(self) end)
		c:SetHandler('OnMouseDown',function(self,button)
			if button == 2 then
				AG4.setdata[nr].Skill[x] = {0,0,0}
				AG4.ShowButton(self)
			elseif button == 1 then AG4.LoadSkill(nr,x) end
		end)
		s = WM:CreateControl('AG_Button_Skill_'..nr..'_'..x..'Bg', c, CT_BACKDROP)
		s:SetAnchor(128,c,128,0,0)
		s:SetDimensions(44,44)
		s:SetCenterColor(0,0,0,0.2)
		s:SetEdgeColor(0,0,0,0)
		s:SetEdgeTexture('',1,1,2)
		s:SetInsets(2,2,-2,-2)
		AG4.ShowButton(c)
	end
end
function AG4.DrawGearButton(nr)
	local c, s, l
	s = WM:CreateControl('AG_Selector_Gear_'..nr, AG_PanelGearPanelScrollChild, CT_BUTTON)
	s:SetAnchor(3,nil,3,0,45*(nr-1))
	s:SetDimensions(635,44)
	s:SetClickSound('Click')
	s:EnableMouseButton(2,true)
	s:SetNormalTexture('AlphaGearX2/grey.dds')
	s:SetMouseOverTexture('AlphaGearX2/light.dds')
	s.data = { header = '|cFFAA33'..L.Head.Gear..nr..'|r', info = L.Selector.Gear }
	s:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	s:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	s:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then
			AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 1),false,true})
			MENU.nr = nr
			MENU.type = 1
		elseif button == 1 then
			if SELECT.on and SELECT.mode == 1 then
				AG4.setdata[SELECT.nr].Set.gear = nr
				WM:GetControlByName('AG_SetButton_'..SELECT.nr..'_'..SELECT.mode):SetText(nr)
			else AG4.LoadGear(nr) end
		end
	end)
	l = WM:CreateControl('AG_Selector_Gear_'..nr..'_Label', s, CT_LABEL)
	l:SetAnchor(3,s,3,0,0)
	l:SetDrawTier(1)
	l:SetDimensions(44,44)
	l:SetHorizontalAlignment(1)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFontBold')
	l:SetColor(1,1,1,0.8)
	l:SetText(nr)
	for x = 1,14 do
		c = WM:CreateControl('AG_Button_Gear_'..nr..'_'..x, s, CT_BUTTON)
		c:SetAnchor(2,s,2,46+42*(x-1),0)
		c:SetDrawTier(1)
		c:SetDimensions(40,40)
		c:SetClickSound('Click')
		c:EnableMouseButton(2,true)
		c:SetMouseOverTexture('AlphaGearX2/light.dds')
		c:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
		c:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
		c:SetHandler('OnReceiveDrag',function(self) AG4.OnDragReceive(self) end)
		c:SetHandler('OnMouseDown',function(self,button)
			if button == 2 then
				AG4.setdata[nr].Gear[x] = {id = 0, link = 0}
				AG4.ShowButton(self)
			elseif button == 1 then AG4.LoadItem(nr,x) end
		end)
		s = WM:CreateControl('AG_Button_Gear_'..nr..'_'..x..'Bg', c, CT_BACKDROP)
		s:SetAnchor(128,c,128,0,0)
		s:SetDimensions(44,44)
		s:SetCenterColor(0,0,0,0.2)
		s:SetEdgeColor(0,0,0,0)
		s:SetEdgeTexture('',1,1,2)
		s:SetInsets(2,2,-2,-2)
		AG4.ShowButton(c)
	end
end
]]
function AG4.DrawSet(nr)
	if WM:GetControlByName('AG_SetSelector_'..nr) then return end
	local p, l, s = AG_PanelSetPanelScrollChild
	s = WM:CreateControl('AG_SetSelector_'..nr, p, CT_BUTTON)
	s:SetAnchor(3,nil,3,0,81*(nr-1))
	s:SetDimensions(311,76)
	s:SetClickSound('Click')
	s:EnableMouseButton(2,true)
	s:SetNormalTexture('AlphaGearX2/grey.dds')
	s:SetMouseOverTexture('AlphaGearX2/light.dds')
	s:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	s:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	s:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then
			-- AG4.DrawMenu(self,{false,false,false,true,true})
			-- MENU.nr = nr
			-- MENU.type = 3
			AG4.ShowEditPanel()
		elseif button == 1 then
			AG4.LoadSet(nr)
		end
	end)
	l = WM:CreateControl('AG_SetSelector_'..nr..'_Label', s, CT_LABEL)
	l:SetAnchor(3,s,3,0,0)
	l:SetDrawTier(1)
	l:SetDimensions(44,44)
	l:SetHorizontalAlignment(1)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFontBold')
	l:SetColor(1,1,1,0.8)
	l:SetText(nr)
	l = WM:CreateControl('AG_SetSelector_'..nr..'_KeyBind', s, CT_LABEL)
	l:SetAnchor(9,s,9,-15,0)
	l:SetDrawTier(1)
	l:SetDimensions(235,44)
	l:SetHorizontalAlignment(2)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.5)
	l = WM:CreateControl('AG_SetButton_'..nr..'_Box', s, CT_LABEL)
	l:SetAnchor(3,s,3,2,44)
	l:SetDrawTier(1)
	l:SetDimensions(307,30)
	l:SetHorizontalAlignment(0)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.8)
	s = WM:CreateControl('AG_SetButton_'..nr..'_BoxBg', l, CT_BACKDROP)
	s:SetAnchorFill()
	s:SetCenterColor(0,0,0,0.2)
	s:SetEdgeColor(0,0,0,0)
	s:SetEdgeTexture('',1,1,2)
end
function AG4.DrawOptions()
	for x,opt in pairs(L.options) do
		if opt == '-' then
		else
		end
	end
end
function AG4.ReadIcons()
	for file in io.popen([[dir "C:\Program Files\" /b]]):lines() do
		print(file)
	end
end

function AG4.GetKey(keyStr)
	local modifier = ''
	local l,c,a = GetActionIndicesFromName(keyStr)
	local key,m1,m2,m3,m4 = GetActionBindingInfo(l,c,a,1)
	if key ~= KEY_INVALID then
		local shift = ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_SHIFT,m1,m2,m3,m4)
		local ctrl = ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_CTRL,m1,m2,m3,m4)
		local alt = ZO_Keybindings_DoesKeyMatchAnyModifiers(KEY_ALT,m1,m2,m3,m4)
		if alt then modifier = modifier..string.format('%s-',string.upper(string.sub(GetString(SI_KEYCODEALT),1,8)))
		elseif ctrl then modifier = modifier..string.format('%s-',string.upper(string.sub(GetString(SI_KEYCODECTRL),1,8)))
		elseif shift then modifier = modifier..string.format('%s-',string.upper(string.sub(GetString(SI_KEYCODESHIFT),1,8))) end
		return modifier..GetKeyName(key)
	else return '' end
end
function AG4.GetButton(c)
	local res, name = {}, {string.match(c:GetName(),'AG_(%a+)_(%a+)_(%d+)_(%d+)')}
	table.insert(res, name[2])
	table.insert(res, tonumber(name[3]))
	table.insert(res, tonumber(name[4]))
	return unpack(res)
end
function AG4.GetSoulgem()
	local result, tier = false, 0
	local bag = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	for _,data in pairs(bag) do
		if IsItemSoulGem(SOUL_GEM_TYPE_FILLED,BAG_BACKPACK,data.slotIndex) then
			local geminfo = GetSoulGemItemInfo(BAG_BACKPACK,data.slotIndex)
			if geminfo > tier then tier = geminfo; result = data.slotIndex end
		end
	end
	return result
end
function AG4.GetItemFromBag(id)
	if not id then return false end
	local bag = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	for slot,data in pairs(bag) do if id == Id64ToString(data.uniqueId) then return slot end end
	return false
end

function AG4.OnDragReceive(c)
	local function Contains(tab,item) for _, value in pairs(tab) do if value == item then return true end end return false end
	local function CheckItems(nr,target)
		local clear, et1, et2 = false, GetItemLinkEquipType(AG4.setdata[nr].Gear[1].link), GetItemLinkEquipType(AG4.setdata[nr].Gear[3].link)
		if DRAGINFO.type == EQUIP_TYPE_TWO_HAND then
			if target == 1 then clear = 2 elseif target == 3 then clear = 4 end
		elseif DRAGINFO.type == EQUIP_TYPE_ONE_HAND or DRAGINFO.type == EQUIP_TYPE_OFF_HAND then
			if target == 2 and et1 == EQUIP_TYPE_TWO_HAND then clear = 1 elseif target == 4 and et2 == EQUIP_TYPE_TWO_HAND then clear = 3 end
		end
		if clear then
			AG4.setdata[nr].Gear[clear] = { id = 0, link = 0 }
			AG4.ShowButton(WM:GetControlByName('AG_Button_Gear_'..nr..'_'..clear))
		end
		for _,slot in pairs(DUPSLOTS) do
			if AG4.setdata[nr].Gear[slot].id == DRAGINFO.uid then
				AG4.setdata[nr].Gear[slot] = { id = 0, link = 0 }
				AG4.ShowButton(WM:GetControlByName('AG_Button_Gear_'..nr..'_'..slot))
				return
			end
		end
	end
	local function CheckSkills(nr)
		for x = 1,5 do
			if AG4.setdata[nr].Skill[x][1] == DRAGINFO.skill and AG4.setdata[nr].Skill[x][2] == DRAGINFO.line and AG4.setdata[nr].Skill[x][3] == DRAGINFO.id then
				AG4.setdata[nr].Skill[x] = {0,0,0}
				AG4.ShowButton(WM:GetControlByName('AG_Button_Skill_'..nr..'_'..x))
				return
			end
		end
	end
	local function DragItem(btn)
		local _, nr, slot = AG4.GetButton(btn)
		if DRAGINFO.uid and Contains(DRAGINFO.slot,slot)then
			if Contains(DUPSLOTS,slot) then CheckItems(nr,slot) end
			AG4.setdata[nr].Gear[slot] = { id = DRAGINFO.uid, link = DRAGINFO.link }
			AG4.ShowButton(btn)
			ClearCursor()
			PlaySound('Tablet_PageTurn')
		end
	end
	local function DragSkill(btn)
		local _, nr, slot = AG4.GetButton(btn)
		if DRAGINFO.skill then
			if (not DRAGINFO.ultimate and slot < 6) or (DRAGINFO.ultimate and slot == 6) then
				if slot < 6 then CheckSkills(nr) end
				AG4.setdata[nr].Skill[slot] = { DRAGINFO.skill, DRAGINFO.line, DRAGINFO.id }
				AG4.ShowButton(btn)
				ClearCursor()
				PlaySound('Tablet_PageTurn')
			end
		end
	end
	local cursor = GetCursorContentType()
	if cursor == MOUSE_CONTENT_INVENTORY_ITEM or cursor == MOUSE_CONTENT_EQUIPPED_ITEM then DragItem(c)
	elseif cursor == MOUSE_CONTENT_ACTION then DragSkill(c) end
end
function AG4.OnSkillDragStart(c)
    if GetCursorContentType() == MOUSE_CONTENT_EMPTY and not AG_Panel:IsHidden() then
		local _,_,_,_,ultimate,active = GetSkillAbilityInfo(c.skillType, c.lineIndex, c.index)
		if active then
			DRAGINFO.skill		= c.skillType
			DRAGINFO.line		= c.lineIndex
			DRAGINFO.id			= c.index
			DRAGINFO.ultimate	= ultimate
			DRAGINFO.source 	= c
			DRAGINFO.slot 		= {1,2,3,4,5}
			if ultimate then DRAGINFO.slot = {6} end
			AG4.SetCallout('Skill',1)
			c:RegisterForEvent(EVENT_CURSOR_DROPPED, function() AG4.SetCallout('Skill',0) end)
		end
    end
end
function AG4.OnItemDragStart(invSlot)
    if GetCursorContentType() == MOUSE_CONTENT_EMPTY and not AG_Panel:IsHidden() then
		local bag, slot
		if invSlot.dataEntry then bag, slot = invSlot.dataEntry.data.bagId, invSlot.dataEntry.data.slotIndex
		else bag, slot = invSlot.bagId, invSlot.slotIndex end
		local _,_,_,_,_,et = GetItemInfo(bag, slot)
		if et ~= EQUIP_TYPE_INVALID then
			local gear = {
				[EQUIP_TYPE_HEAD] = { 5 },
				[EQUIP_TYPE_CHEST] = { 6 },
				[EQUIP_TYPE_LEGS] = { 7 },
				[EQUIP_TYPE_SHOULDERS] = { 8 },
				[EQUIP_TYPE_FEET] = { 9 },
				[EQUIP_TYPE_WAIST] = { 10 },
				[EQUIP_TYPE_HAND] = { 11 },
				[EQUIP_TYPE_NECK] = { 12 },
				[EQUIP_TYPE_RING] = { 13, 14 },
				[EQUIP_TYPE_MAIN_HAND] = { 1, 3 },
				[EQUIP_TYPE_ONE_HAND] = { 1, 2, 3, 4 },
				[EQUIP_TYPE_TWO_HAND] = { 1, 3 },
				[EQUIP_TYPE_OFF_HAND] = { 2, 4 },
			}
			DRAGINFO.link = GetItemLink(bag, slot)
			DRAGINFO.uid = Id64ToString(GetItemUniqueId(bag, slot))
			DRAGINFO.type = et
			DRAGINFO.slot = gear[et]
			DRAGINFO.source = invSlot
			AG4.SetCallout('Gear',1)
			invSlot:RegisterForEvent(EVENT_CURSOR_DROPPED, function() AG4.SetCallout('Gear',0) end)
		end
    end
end

function AG4.LoadItem(nr,slot)
	if not nr or not slot then return end
	if AG4.setdata[nr].Gear[slot].id ~= 0 then
		if Id64ToString(GetItemUniqueId(BAG_WORN,SLOTS[slot][1])) ~= AG4.setdata[nr].Gear[slot].id then
			local bagSlot = AG4.GetItemFromBag(AG4.setdata[nr].Gear[slot].id)
			if bagSlot then EquipItem(BAG_BACKPACK,bagSlot,SLOTS[slot][1])
			else
				for _,x in pairs(DUPSLOTS) do
					if Id64ToString(GetItemUniqueId(BAG_WORN,x)) == AG4.setdata[nr].Gear[slot].id then
						EquipItem(BAG_WORN,x,SLOTS[slot][1])
						return
					end
				end
				d(ZOSF(L.NotFound,AG4.setdata[nr].Gear[slot].link))
			end
		end
	elseif AG4.setdata[nr].lock == 1 then table.insert(GEARQUEUE,slot) end
end
function AG4.LoadSkill(nr,slot)
    if not nr or not slot or AG4.setdata[nr].Skill[slot][1] == 0 then return end
	local slotted = GetAssignedSlotFromSkillAbility(AG4.setdata[nr].Skill[slot][1], AG4.setdata[nr].Skill[slot][2], AG4.setdata[nr].Skill[slot][3])
	if not slotted or slotted ~= slot + 2 then
		SlotSkillAbilityInSlot(AG4.setdata[nr].Skill[slot][1], AG4.setdata[nr].Skill[slot][2], AG4.setdata[nr].Skill[slot][3], slot + 2)
	end
end
function AG4.LoadBar(nr)
	if not nr then return end
	for slot = 1,6 do AG4.LoadSkill(nr,slot) end
end
function AG4.LoadGear(nr)
	if not nr then return end
	for x = 1,14 do AG4.LoadItem(nr,x) end
end
function AG4.LoadSet(nr)
	if not nr then return end
	AG4.account.lastset = nr
	local pair,_ = GetActiveWeaponPairInfo()
	if AG4.setdata[nr].Set.gear > 0 then AG4.LoadGear(AG4.setdata[nr].Set.gear) end
	if AG4.setdata[nr].Set.skill[pair] > 0 then AG4.LoadBar(AG4.setdata[nr].Set.skill[pair]) end
	SWAP = true
end

function AG4.Undress(mode)
	if mode == 1 then for x = 5,11 do table.insert(GEARQUEUE,SLOTS[x][1]) end
	else for _,x in pairs(SLOTS) do table.insert(GEARQUEUE,x[1]) end end
end
function AG4.Queue()
     if AG4.init then
		if GEARQUEUE[1] then
			if GetItemInstanceId(BAG_WORN,GEARQUEUE[1]) then
				if GetNumBagFreeSlots(BAG_BACKPACK) > 0 then UnequipItem(GEARQUEUE[1])
				else
					d(L.NotEnoughSpace)
					GEARQUEUE = {}
				end
			else table.remove(GEARQUEUE,1) end
		end
     end
end

function AG4.UpdateRepair(_,bag)
	if bag ~= BAG_WORN then return end
	local condition, count, allcost = 0, 0, 0
	for _,c in pairs(SLOTS) do
		if GetItemInstanceId(BAG_WORN,c[1]) then
			condition = condition + GetItemCondition(BAG_WORN,c[1])
			allcost = allcost + GetItemRepairCost(BAG_WORN,c[1])
			count = count + 1
		end
	end
	condition = math.floor(condition/count) or 0
	local r,g,b = GetColor(condition)
	AG_RepairTex:SetColor(r,g,b,1)
	AG_RepairValue:SetText(condition..'%')
	AG_RepairValue:SetColor(r,g,b,1)
	AG_RepairCost:SetText(allcost..' |t12:12:esoui/art/currency/currency_gold.dds|t')
end
function AG4.UpdateCondition(_,bag,slot)
	if bag ~= BAG_WORN or slot == EQUIP_SLOT_COSTUME then return end
	local t, l = WM:GetControlByName('AG_InvBg'..slot), WM:GetControlByName('AG_InvBg'..slot..'Condition')
	local p = t:GetParent()
	p:SetMouseOverTexture(not ZO_Character_IsReadOnly() and 'AlphaGearX2/mo.dds' or nil)
	p:SetPressedMouseOverTexture(not ZO_Character_IsReadOnly() and 'AlphaGearX2/mo.dds' or nil)
	if GetItemInstanceId(BAG_WORN,slot) then
		local r,g,b = unpack(QUALITY[GetItemLinkQuality(GetItemLink(BAG_WORN,slot))])
		t:SetHidden(false)
		t:SetColor(r,g,b,1)
		if AG4.account.option[11] and DoesItemHaveDurability(BAG_WORN,slot) then
			local con = GetItemCondition(BAG_WORN,slot)
			local r,g,b = GetColor(con)
			l:SetText(con..'%')
			l:SetColor(r,g,b,0.9)
			l:SetHidden(false)
		else l:SetHidden(true) end
	else
		t:SetHidden(false)
		l:SetHidden(false)
	end
end
function AG4.UpdateCharge(_,bag)
	if bag ~= BAG_WORN then return end
	local pair = GetActiveWeaponPairInfo()
	local w1,w2,c1,c2,g1,g2
	if pair == 1 then
		g1 = EQUIP_SLOT_MAIN_HAND
		if IsItemChargeable(BAG_WORN,g1)then
			c1 = {GetChargeInfoForItem(BAG_WORN,g1)}
			w1 = GetItemInfo(BAG_WORN,g1)
		end
		g2 = EQUIP_SLOT_OFF_HAND
		if IsItemChargeable(BAG_WORN,g2)then
			c2 = {GetChargeInfoForItem(BAG_WORN,g2)}
			w2 = GetItemInfo(BAG_WORN,g2)
		end
	else
		g1 = EQUIP_SLOT_BACKUP_MAIN
		if IsItemChargeable(BAG_WORN,g1)then
			c1 = {GetChargeInfoForItem(BAG_WORN,g1)}
			w1 = GetItemInfo(BAG_WORN,g1)
		end
		g2 = EQUIP_SLOT_BACKUP_OFF
		if IsItemChargeable(BAG_WORN,g2)then
			c2 = {GetChargeInfoForItem(BAG_WORN,g2)}
			w2 = GetItemInfo(BAG_WORN,g2)
		end
	end
	if w1 then
		local charge = math.floor(c1[1]/c1[2]*100)
		local r,g,b = GetColor(charge)
		AG_Charge1Tex:SetTexture(w1)
		AG_Charge1Value:SetText(charge.."%")
		AG_Charge1Value:SetColor(r,g,b,1)
		AG_Charge1:SetHidden(false)
		if c1[1] < 1 and AG4.account.option[15] then
			local gem = AG4.GetSoulgem()
			if gem then
				ChargeItemWithSoulGem(BAG_WORN,g1,BAG_BACKPACK,gem)
				d(ZOSF(L.SoulgemUsed,GetItemName(BAG_WORN,g1)))
			end
		end
	else AG_Charge1:SetHidden(true) end
	if w2 then
		local charge = math.floor(c2[1]/c2[2]*100)
		local r,g,b = GetColor(charge)
		AG_Charge2Tex:SetTexture(w2)
		AG_Charge2Value:SetText(charge.."%")
		AG_Charge2Value:SetColor(r,g,b,1)
		AG_Charge2:SetHidden(false)
		if c2[1] < 1 and AG4.account.option[15] then
			local gem = AG4.GetSoulgem()
			if gem then
				ChargeItemWithSoulGem(BAG_WORN,g2,BAG_BACKPACK,gem)
				d(ZOSF(L.SoulgemUsed,GetItemName(BAG_WORN,g2)))
			end
		end
	else AG_Charge2:SetHidden(true) end
end
function AG4.UpdateUI(from,to)
	if not from then from = 1 end
	if not to then to = MAXSLOT end
	local text
	for x = from, to do
		if AG4.setdata[x].Set.text == 0 then text = 'Set '..x else text = AG4.setdata[x].Set.text[1] end
		local header, c = '|c00DD00'..text..'|r', ''
		WM:GetControlByName('AG_SetSelector_'..x).data = { header = header, info = L.Set }
		WM:GetControlByName('AG_SetSelector_'..x..'_KeyBind'):SetText(AG4.GetKey('AG4_SET_'..x))
		-- c = WM:GetControlByName('AG_SetButton_'..x..'_1')
		-- if AG4.setdata[x].Set.gear ~= 0 then c:SetText(AG4.setdata[x].Set.gear) else c:SetText('') end
		-- c.data = { header = header, info = L.SetConnector[1] }
		-- c = WM:GetControlByName('AG_SetButton_'..x..'_2')
		-- if AG4.setdata[x].Set.skill[1] ~= 0 then c:SetText(AG4.setdata[x].Set.skill[1]) else c:SetText('') end
		-- c.data = { header = header, info = L.SetConnector[2] }
		-- c = WM:GetControlByName('AG_SetButton_'..x..'_3')
		-- if AG4.setdata[x].Set.skill[2] ~= 0 then c:SetText(AG4.setdata[x].Set.skill[2]) else c:SetText('') end
		-- c.data = { header = header, info = L.SetConnector[3] }
		c = WM:GetControlByName('AG_SetButton_'..x..'_Box')
		c:SetText('  '..text)
		-- c.data = { header = header, info = L.Edit }
		-- WM:GetControlByName('AG_SetButton_'..x..'_BoxEdit'):SetText(text)
	end
end

function AG4.SetCallout(panel,mode)
	for a = 1, MAXSLOT do
		for _,b in pairs(DRAGINFO.slot) do
			WM:GetControlByName('AG_Button_'..panel..'_'..a..'_'..b..'Bg'):SetEdgeColor(0,1,0,mode)
		end
	end
	if mode == 0 then
		DRAGINFO.source:UnregisterForEvent(EVENT_CURSOR_DROPPED)
		DRAGINFO = {}
	end
end
function AG4.SetConnect(parent,mode)
	local col, p = {'green','grey'}, {'Gear','Skill','Skill'}
	for nr = 1, MAXSLOT do
		WM:GetControlByName('AG_Selector_'..p[parent]..'_'..nr):SetNormalTexture('AlphaGearX2/'..col[mode]..'.dds')
	end
end
function AG4.SetOptions()
	AG_Repair:SetHidden(not AG4.account.option[3])
	AG_RepairCost:SetHidden(not AG4.account.option[4])
	if AG4.account.option[3] then
		EM:RegisterForEvent('AG_Event_Repair',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateRepair)
		AG4.UpdateRepair(nil,BAG_WORN)
	else EM:UnregisterForEvent('AG_Event_Repair',EVENT_INVENTORY_SINGLE_SLOT_UPDATE) end
	
	AG_Charge1:SetHidden(not AG4.account.option[5])
	AG_Charge2:SetHidden(not AG4.account.option[5])
	if AG4.account.option[5] then
		EM:RegisterForEvent('AG_Event_Charge',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateCharge)
		AG4.UpdateCharge(nil,BAG_WORN)
	else EM:UnregisterForEvent('AG_Event_Charge',EVENT_INVENTORY_SINGLE_SLOT_UPDATE) end

	if AG4.account.option[10] then
		EM:RegisterForEvent('AG_Event_Condition',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateCondition)
		for _,c in pairs(SLOTS) do AG4.UpdateCondition(_,BAG_WORN,c[1]) end
	else
		EM:UnregisterForEvent('AG_Event_Condition',EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		for _,c in pairs(SLOTS) do AG4.UpdateCondition(_,BAG_WORN,c[1]) end
	end
	AG_UI_Button:SetHidden(not AG4.account.option[1])
	AG_UI_ButtonBg:SetMouseEnabled(AG4.account.option[1])
	AG_UI_ButtonBg:SetMovable(AG4.account.option[1])
	AG_UI_Button.data = { tip = AG4.name }
end
function AG4.SetPosition(parent,pos)
	AG_Panel:ClearAnchors()
	AG_Panel:SetAnchor(8,parent,2,pos,0)
end

function AG4.ResetPosition()
	AG_Panel:ClearAnchors()
	AG_Panel:SetAnchor(3,GuiRoot,3,AG4.account.pos[1],AG4.account.pos[2])
	AG_UI_ButtonBg:ClearAnchors()
	AG_UI_ButtonBg:SetAnchor(3,GuiRoot,3,AG4.account.button[1],AG4.account.button[2])
end
function AG4.ShowButton(c)
	if not c then return false end
	local type, nr, slot = AG4.GetButton(c)
	if type == 'Skill' then
		if AG4.setdata[nr].Skill[slot][1] ~= 0 then
			local _,icon = GetSkillAbilityInfo(AG4.setdata[nr].Skill[slot][1],AG4.setdata[nr].Skill[slot][2],AG4.setdata[nr].Skill[slot][3])
			c:SetNormalTexture(icon)
			c.data = { hint = '\n'..L.Button[type] }
		else
			c:SetNormalTexture()
			c.data = nil
		end
	else
		if AG4.setdata[nr].Gear[slot].link ~= 0 then
			c:SetNormalTexture(GetItemLinkInfo(AG4.setdata[nr].Gear[slot].link))
			local color = QUALITY[GetItemLinkQuality(AG4.setdata[nr].Gear[slot].link)]
			c:GetNamedChild('Bg'):SetCenterColor(color[1],color[2],color[3],0.75)
			c.data = { hint = '\n'..L.Button[type] }
		else
			c:SetNormalTexture('esoui/art/characterwindow/gearslot_'..SLOTS[slot][2]..'.dds')
			c:GetNamedChild('Bg'):SetCenterColor(0,0,0,0.2)
			c.data = nil
		end
	end
end
function AG4.ShowMain()
	SM:ToggleTopLevel(AG_Panel)
	if not AG_Panel:IsHidden() then AG4.UpdateUI() end
end
function AG4.ShowEditPanel()
	AG_PanelSetPanel:ToggleHidden()
	AG_PanelEditPanel:ToggleHidden()
end
function AG4.Swap(_,isSwap)
    if isSwap and not IsBlockActive()then
		if AG4.account.lastset and SWAP then
			local pair,_ = GetActiveWeaponPairInfo()
			if AG4.setdata[AG4.account.lastset].Set.skill[pair] > 0 then AG4.LoadBar(AG4.setdata[AG4.account.lastset].Set.skill[pair]) end
			SWAP = false
		end
		AG4.UpdateCharge(nil,BAG_WORN)
    end
end
function AG4.MenuAction(nr)
	if nr == 1 then
		MENU.copy = MENU.nr
	elseif nr == 2 and MENU.copy then
		if MENU.type == 1 then for z = 1,14 do
			AG4.setdata[MENU.nr].Gear[z] = AG4.setdata[MENU.copy].Gear[z]
			AG4.ShowButton(WM:GetControlByName('AG_Button_Gear_'..MENU.nr..'_'..z))
		end	else for z = 1,6 do
			AG4.setdata[MENU.nr].Skill[z] = AG4.setdata[MENU.copy].Skill[z]
			AG4.ShowButton(WM:GetControlByName('AG_Button_Skill_'..MENU.nr..'_'..z))
		end end
	elseif nr == 3 then
		for x = 1,14 do
			if GetItemInstanceId(BAG_WORN,SLOTS[x][1]) then
				AG4.setdata[MENU.nr].Gear[x] = { id = Id64ToString(GetItemUniqueId(BAG_WORN,SLOTS[x][1])), link = GetItemLink(BAG_WORN,SLOTS[x][1]) }
			else AG4.setdata[MENU.nr].Gear[x] = { id = 0, link = 0 } end
			AG4.ShowButton(WM:GetControlByName('AG_Button_Gear_'..MENU.nr..'_'..x))
		end
	elseif nr == 4 then
		if MENU.type == 1 then for z = 1,14 do
			AG4.setdata[MENU.nr].Gear[z] = { id = 0, link = 0 }
			AG4.ShowButton(WM:GetControlByName('AG_Button_Gear_'..MENU.nr..'_'..z))
		end	elseif MENU.type == 2 then for z = 1,6 do
			AG4.setdata[MENU.nr].Skill[z] = {0,0,0}
			AG4.ShowButton(WM:GetControlByName('AG_Button_Skill_'..MENU.nr..'_'..z))
		end else
			AG4.setdata[MENU.nr].Set = { text = {0,0,0}, gear = 0, skill = {0,0}, icon = {0,0}, lock = 0 }
			AG4.UpdateUI(MENU.nr,MENU.nr)
		end
	-- elseif nr == 4 then
		-- WM:GetControlByName('AG_SetButton_'..MENU.nr..'_Box'):SetHidden(true)
		-- local c = WM:GetControlByName('AG_SetButton_'..MENU.nr..'_BoxEdit')
		-- c:SetHidden(false)
		-- c:TakeFocus()
	end
end
function AG4.Tooltip(c,visible)
	function FadeIn(control)
		TTANI = ANIMATION_MANAGER:CreateTimeline()
		local fadeIn = TTANI:InsertAnimation(ANIMATION_ALPHA,control,500)
		fadeIn:SetAlphaValues(0,1)
		fadeIn:SetDuration(150)
		TTANI:PlayFromStart()
	end
	if not c then return end
	if visible then
		local type, nr, slot = AG4.GetButton(c)
		if type == 'Gear' then
			if AG4.setdata[nr].Gear[slot].link == 0 then return end
			c.text = ItemTooltip
			InitializeTooltip(c.text,AG_Panel,3,0,0,9)
			c.text:SetLink(AG4.setdata[nr].Gear[slot].link)
			ZO_ItemTooltip_ClearCondition(c.text)
			ZO_ItemTooltip_ClearCharges(c.text)
		elseif type == 'Skill' then
			if AG4.setdata[nr].Skill[slot][1] == 0 then return end
			c.text = SkillTooltip
			InitializeTooltip(c.text,AG_Panel,3,0,0,9)
			c.text:SetSkillAbility(AG4.setdata[nr].Skill[slot][1], AG4.setdata[nr].Skill[slot][2], AG4.setdata[nr].Skill[slot][3])
		elseif c.data.tip then
			c.text = InformationTooltip
			InitializeTooltip(c.text,c,2,5,0,8)
			SetTooltipText(c.text,c.data.tip)
			c.text:SetHidden(false)
			return
		else
			if c.data == nil then return end
			c.text = InformationTooltip
			InitializeTooltip(c.text,AG_Panel,3,0,0,9)
			if c.data.header then c.text:AddLine(c.data.header,'ZoFontWinH4') end
			SetTooltipText(c.text,c.data.info)
		end
		if c.data and c.data.hint then c.text:AddLine('\n'..c.data.hint,'ZoGameFont') end
		c.text:SetAlpha(0)
		c.text:SetHidden(false)
		FadeIn(c.text)
	else
		if c.text == nil then return end
		ClearTooltip(c.text)
		if TTANI then TTANI:Stop() end
		c.text:SetHidden(true)
		c.text = nil
	end
end

function KEYBINDING_MANAGER:IsChordingAlwaysEnabled() return true end

EM:RegisterForEvent('AG4',EVENT_ADD_ON_LOADED,function(_,name)
	if name ~= AG4.name then return end
	SM:RegisterTopLevel(AG_Panel,false)
    EM:UnregisterForEvent('AG4',EVENT_ADD_ON_LOADED)
	EM:RegisterForEvent('AG4',EVENT_ACTION_SLOTS_FULL_UPDATE, AG4.Swap)

	local init_account = {
		option = {true,true,true,true,true,true,false,true,true,true,true,true,true,true},
		pos = {GuiRoot:GetWidth()/2 - 335, GuiRoot:GetHeight()/2 - 410},
		button = {50,100},
		lastset = false,
	}
	local init_data = {}
	for x = 1, MAXSLOT do
		init_data[x] = {
			Gear = {}, Skill = {},
			Set = { text = {0,0,0}, gear = 0, skill = {0,0}, icon = {0,0}, lock = 0 }
		}
		for z = 1,14 do init_data[x].Gear[z] = { id = 0, link = 0 } end
		for z = 1,6 do init_data[x].Skill[z] = { 0,0,0 } end
	end
	AG4.setdata = ZO_SavedVars:New('AGX2_Character',3,nil,init_data)
	AG4.account = ZO_SavedVars:NewAccountWide('AGX2_Account',3,nil,init_account)
	ZO_CreateStringId('SI_BINDING_NAME_SHOW_AG_WINDOW', 'AlphaGearX2')
	ZO_CreateStringId('SI_BINDING_NAME_AG4_UNDRESS', 'Unequip all Armor')
	for x = 1, MAXSLOT do
		ZO_CreateStringId('SI_BINDING_NAME_AG4_SET_'..x, 'Load Set '..x)
		AG4.DrawSet(x)
		AG4.DrawButtonLine(1,x)
		AG4.DrawButtonLine(2,x)
	end
	for x = 1,6 do
		AG4.DrawButton(AG_PanelEditPanelSkill1Box,'Edit','Skill',1,x,42*(x-1),0,true)
		AG4.DrawButton(AG_PanelEditPanelSkill2Box,'Edit','Skill',2,x,42*(x-1),0,true)
	end
	for x = 1,2 do
		AG4.DrawButton(AG_PanelEditPanelW1Box,'Edit','Gear',1,x,42*(x-1),0,true)
		AG4.DrawButton(AG_PanelEditPanelW2Box,'Edit','Gear',1,x+2,42*(x-1),0,true)
	end
	for x = 5,11 do AG4.DrawButton(AG_PanelEditPanelGearBox,'Edit','Gear',1,x,42*(x-5),0,true) end
	for x = 12,14 do AG4.DrawButton(AG_PanelEditPanelJewelryBox,'Edit','Gear',1,x,42*(x-12),0,true) end

	ZO_PreHook('ZO_Skills_AbilitySlot_OnDragStart', AG4.OnSkillDragStart)
	ZO_PreHook('ZO_InventorySlot_OnDragStart', AG4.OnItemDragStart)
	ZO_PreHookHandler(AG_PanelMenu,'OnShow', function()
		zo_callLater(function() EM:RegisterForEvent('AG4',EVENT_GLOBAL_MOUSE_UP,function()
			AG_PanelMenu:SetHidden(true)
			EM:UnregisterForEvent('AG4',EVENT_GLOBAL_MOUSE_UP)
		end) end, 250)
	end)
	ZO_PreHookHandler(ZO_Skills,'OnShow', function() AG4.SetPosition(ZO_Skills,-25) end)
	ZO_PreHookHandler(ZO_Skills,'OnHide', AG4.ResetPosition)
	ZO_PreHookHandler(ZO_PlayerInventory,'OnShow', function() AG4.SetPosition(ZO_PlayerInventory,0) end)
	ZO_PreHookHandler(ZO_PlayerInventory,'OnHide', AG4.ResetPosition)
	ZO_PreHookHandler(ZO_ChampionPerks,'OnShow', function() SM:HideTopLevel(AG_Panel) end)
	
	AG_PanelSetPanel.useFadeGradient = false
	AG_PanelGearPanel.useFadeGradient = false
	AG_PanelSkillPanel.useFadeGradient = false

	AG4.DrawInventory()
	AG4.ResetPosition()
	AG4.SetOptions()
	AG4.init = true
end)
