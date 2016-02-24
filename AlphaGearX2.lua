AG4.name = 'AlphaGearX2'
AG4.version = '4.00'
AG4.init = false
AG4.account = {}
AG4.setdata = {}
local L, ZOSF, FUNC1, FUNC2 = AG4[GetCVar('language.2')] or AG4.en, zo_strformat, nil, nil
local MAXSLOT, MENU, SELECT, SELECTBAR, DRAGINFO, TTANI, SWAP = 16, { nr = nil, type = nil, copy = nil }, false, false, {}, false, false
local EM, WM, SM, ICON, MESSAGE = EVENT_MANAGER, WINDOW_MANAGER, SCENE_MANAGER, {}
local OPT, GEARQUEUE, SLOTS, DUPSLOTS = {}, {}, {
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

local function GetColor(val,a)
	local r,g = 0,0
	if val >= 50 then r = 100-((val-50)*2); g = 100 else r = 100; g = val*2 end
	return r/100, g/100, 0, a
end
local function Quality(link,a)
	local QUALITY = {[0]={0.65,0.65,0.65,a},[1]={1,1,1,a},[2]={0.17,0.77,0.05,a},[3]={0.22,0.57,1,a},[4]={0.62,0.18,0.96,a},[5]={0.80,0.66,0.10,a}}
	return unpack(QUALITY[GetItemLinkQuality(link)])
end
local function Zero(val) if val == 0 then return nil else return val end end

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
		s:SetAnchor(TOPRIGHT,p,TOPRIGHT,7,-8)
		s:SetDimensions(50,10)
		s:SetHidden(true)
		s:SetHorizontalAlignment(2)
	end
end
function AG4.DrawButton(p,name,btn,nr,x,xpos,ypos,show)
	local c = WM:CreateControl('AG_'..name..'_'..btn..'_'..nr..'_'..x, p, CT_BUTTON)
	if show then c:SetAnchor(3,p,3,xpos,ypos) else c:SetAnchor(2,p,2,xpos,ypos) end
	c:SetDrawTier(1)
	c:SetDimensions(40,40)
	c:SetMouseOverTexture('AlphaGearX2/light.dds')
	c:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true,show) end)
	c:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false,show) end)
	local b = WM:CreateControl('AG_'..name..'_'..btn..'_'..nr..'_'..x..'Bg', c, CT_BACKDROP)
	b:SetAnchor(128,c,128,0,0)
	b:SetDimensions(44,44)
	b:SetCenterColor(0,0,0,0.2)
	b:SetEdgeColor(0,0,0,0)
	b:SetEdgeTexture('',1,1,2)
	b:SetInsets(2,2,-2,-2)
	if not show then
		c:SetClickSound('Click')
		c:EnableMouseButton(2,true)
		c:SetHandler('OnReceiveDrag',function(self) AG4.OnDragReceive(self) end)
		if btn == 'Gear' then c:SetHandler('OnMouseDown',function(self,button) if button == 2 then AG4.setdata[nr].Gear[x] = { id = 0, link = 0 }; AG4.ShowButton(self) elseif button == 1 then AG4.LoadItem(nr,x) end end) end
		if btn == 'Skill' then c:SetHandler('OnMouseDown',function(self,button) if button == 2 then AG4.setdata[nr].Skill[x] = {0,0,0}; AG4.ShowButton(self) elseif button == 1 then AG4.LoadSkill(nr,x) end end) end
		AG4.ShowButton(c)
	end
end
function AG4.DrawButtonLine(mode,nr)
	local dim,count,btn,c,p = {635,299},{14,6},{'Gear','Skill'}
	if mode == 1 then p = WM:CreateControl('AG_Selector_Gear_'..nr, AG_PanelGearPanelScrollChild, CT_BUTTON)
	else p = WM:CreateControl('AG_Selector_Skill_'..nr, AG_PanelSkillPanelScrollChild, CT_BUTTON) end
	p:SetAnchor(3,nil,3,0,45*(nr-1))
	p:SetDimensions(dim[mode],44)
	p:SetClickSound('Click')
	p:EnableMouseButton(2,true)
	p:SetNormalTexture('AlphaGearX2/grey.dds')
	p:SetMouseOverTexture('AlphaGearX2/light.dds')
	p.data = { header = '|cFFAA33'..L.Head[btn[mode]]..nr..'|r', info = L.Selector[btn[mode]] }
	p:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	p:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	if mode == 1 then p:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 1),true,true}); MENU.nr = nr; MENU.type = mode
		elseif button == 1 then if SELECTBAR then AG4.setdata[SELECT].Set.gear = nr; SELECTBAR = false; AG4.SetConnect(3,2); AG4.UpdateEditPanel(SELECT) else AG4.LoadGear(nr) end end 
	end) end
	if mode == 2 then p:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then AG4.DrawMenu(self,{true,(MENU.copy and MENU.type == 2),false,true}); MENU.nr = nr; MENU.type = mode
		elseif button == 1 then if SELECTBAR then AG4.setdata[SELECT].Set.skill[SELECTBAR] = nr; SELECTBAR = false; AG4.SetConnect(1,2); AG4.UpdateEditPanel(SELECT) else AG4.LoadBar(nr) end end 
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
function AG4.DrawOptions(set)
	local val, tex = {[true]='checked',[false]='unchecked'}, '|t16:16:esoui/art/buttons/checkbox_<<1>>.dds|t |t2:2:x.dds|t '
	local count,rows,row,opt = 1,{6,8,11,13},1,1
	if not set then
		local w,c = L.OptionWidth
		for count = 1,#L.Options + #rows do
			if rows[row] == opt then
				c = WM:CreateControl('AG_OptionRow_'..row, AG_PanelOptionPanel, CT_BUTTON)
				c:SetAnchor(3,AG_PanelOptionPanel,3,10,10+(count-1)*25)
				c:SetDimensions(w-20,25)
				c:SetNormalTexture('AlphaGearX2/row.dds')
				row = row + 1
			else
				c = WM:CreateControl('AG_Option_'..opt, AG_PanelOptionPanel, CT_BUTTON)
				c:SetAnchor(3,AG_PanelOptionPanel,3,10,10+(count-1)*25)
				c:SetDimensions(w-20,25)
				c:SetNormalFontColor(1,1,1,1)
				c:SetMouseOverFontColor(1,0.66,0.2,1)
				c:SetFont('ZoFontGame')
				c:SetHorizontalAlignment(0)
				c:SetVerticalAlignment(1)
				c:SetClickSound('Click')
				c.data = { option = opt }
				c:SetHandler('OnClicked',function(self) AG4.DrawOptions(self.data.option) end)
				c:SetText(ZOSF(tex,val[OPT[opt]])..L.Options[opt])
				opt = opt + 1
			end
		end
		AG_PanelOptionPanel:SetDimensions(w,(opt+row-2)*25+20)
	else
		AG4.account.option[set] = not AG4.account.option[set]
		OPT = AG4.account.option
		WM:GetControlByName('AG_Option_'..set):SetText(ZOSF(tex,val[OPT[set]])..L.Options[set])
		AG4.SetOptions()
	end
end
function AG4.DrawSet(nr)
	local p,l,s = WM:GetControlByName('AG_SetSelector_'..(nr-1)) or false
	local function Slide(sc,fc,sa)
		local ani = ANIMATION_MANAGER:CreateTimeline()
		local slide = ani:InsertAnimation(ANIMATION_SIZE,sc)
		local fade = ani:InsertAnimation(ANIMATION_ALPHA,fc,145)
		fc:SetHidden(not fc:IsHidden())
		fc:SetAlpha(0)
		fade:SetAlphaValues(0,1)
		fade:SetDuration(100)
		slide:SetStartAndEndHeight(76,408)
		slide:SetStartAndEndWidth(311,311)
		slide:SetDuration(150)
		if sa then ani:PlayFromStart() else ani:PlayFromEnd() end
	end
	s = WM:CreateControl('AG_SetSelector_'..nr, AG_PanelSetPanelScrollChild, CT_BUTTON)
	if p then s:SetAnchor(1,p,4,0,5) else s:SetAnchor(3,nil,3,0,0) end
	s:SetDimensions(311,76)
	s:SetClickSound('Click')
	s:EnableMouseButton(2,true)
	s:SetNormalTexture('AlphaGearX2/grey.dds')
	s:SetMouseOverTexture('AlphaGearX2/light.dds')
	s.setnr = nr
	s:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	s:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	s:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then
			local k,anchor = AG_PanelSetPanelScrollChildEditPanel
			anchor = {k:GetAnchor()}
			if anchor[3] and anchor[3] ~= self then
				anchor[3]:SetHeight(76)
				k:SetHidden(true)
				anchor[3]:GetNamedChild('Box'):SetHidden(false)
				anchor[3]:GetNamedChild('Edit'):SetHidden(true)
			end
			k:ClearAnchors()
			k:SetAnchor(6,self,6,2,-2)
			Slide(self,k,k:IsHidden())
			WM:GetControlByName('AG_SetSelector_'..nr..'Box'):ToggleHidden()
			WM:GetControlByName('AG_SetSelector_'..nr..'Edit'):ToggleHidden()
			AG4.UpdateEditPanel(self.setnr)
			AG_PanelIcons:SetHidden(true)
		elseif button == 1 then AG4.LoadSet(nr) end
	end)
	l = WM:CreateControl('AG_SetSelector_'..nr..'Label', s, CT_LABEL)
	l:SetAnchor(3,s,3,0,0)
	l:SetDrawTier(1)
	l:SetDimensions(44,44)
	l:SetHorizontalAlignment(1)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFontBold')
	l:SetColor(1,1,1,1)
	l:SetText(nr)
	l = WM:CreateControl('AG_SetSelector_'..nr..'KeyBind', s, CT_LABEL)
	l:SetAnchor(9,s,9,-15,0)
	l:SetDrawTier(1)
	l:SetDimensions(235,44)
	l:SetHorizontalAlignment(2)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.5)
	l = WM:CreateControl('AG_SetSelector_'..nr..'Box', s, CT_LABEL)
	l:SetAnchor(3,s,3,2,44)
	l:SetDrawTier(1)
	l:SetDimensions(307,30)
	l:SetHorizontalAlignment(0)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.8)
	p = WM:CreateControlFromVirtual('AG_SetSelector_'..nr..'Edit', s, 'ZO_DefaultEditForBackdrop')
	p:ClearAnchors()
	p:SetAnchor(128,l,128,0,4)
	p:SetDimensions(293,30)
	p:SetFont('AGFont')
	p:SetColor(1,1,1,1)
	p:SetMaxInputChars(100)
	p:SetHidden(true)
	p:SetHandler('OnFocusLost',function(self)
		AG4.setdata[nr].Set.text[1] = self:GetText()
		self:LoseFocus()
		AG4.UpdateUI(nr,nr)
	end)
	p:SetHandler('OnEscape',function(self) self:LoseFocus() end)
	p:SetHandler('OnEnter',function(self) self:LoseFocus() end)
	p = WM:CreateControl('AG_SetSelector_'..nr..'BoxBg', s, CT_BACKDROP)
	p:SetDrawTier(1)
	p:SetAnchor(128,l,128,0,0)
	p:SetDimensions(307,30)
	p:SetCenterColor(0,0,0,0.2)
	p:SetEdgeColor(0,0,0,0)
	p:SetEdgeTexture('',1,1,2)
end
function AG4.DrawSetButtonsUI()
	local xpos,ypos,c = 0,0
	for x = 1,MAXSLOT do
		c = WM:CreateControl('AG_UI_SetButton_'..x, AG_SetButtonFrame, CT_BUTTON)
		c:SetAnchor(3,AG_SetButtonFrame,3,xpos,ypos)
		c:SetDimensions(24,24)
		c:SetHorizontalAlignment(1)
		c:SetVerticalAlignment(1)
		c:SetClickSound('Click')
		c:SetFont('AGFontSmall')
		c:SetNormalFontColor(1,1,1,1)
		c:SetMouseOverFontColor(1,0.66,0.2,1)
		c:SetText(x)
		c:SetNormalTexture('AlphaGearX2/grey.dds')
		c:SetMouseOverTexture('AlphaGearX2/light.dds')
		c:SetHandler('OnMouseEnter',function(self) AG4.TooltipSet(x,true) end)
		c:SetHandler('OnMouseExit',function(self) AG4.TooltipSet(x,false) end)
		c:SetHandler('OnClicked',function(self) AG4.LoadSet(x) end)
		if x == MAXSLOT/2 then ypos = ypos + 29; xpos = 0
		else xpos = xpos + 29 end
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
function AG4.GetSetIcon(nr,bar)
	local endicon,gear,icon = nil, AG4.setdata[nr].Gear, {
		[WEAPONTYPE_NONE] = 'nothing',
		[WEAPONTYPE_DAGGER] = 'onehand',
		[WEAPONTYPE_HAMMER] = 'onehand',
		[WEAPONTYPE_AXE] = 'onehand',
		[WEAPONTYPE_SWORD] = 'onehand',
		[WEAPONTYPE_TWO_HANDED_HAMMER] = 'twohand',
		[WEAPONTYPE_TWO_HANDED_AXE] = 'twohand',
		[WEAPONTYPE_TWO_HANDED_SWORD] = 'twohand',
		[WEAPONTYPE_FIRE_STAFF] = 'fire',
		[WEAPONTYPE_FROST_STAFF] = 'frost',
		[WEAPONTYPE_LIGHTNING_STAFF] = 'shock',
		[WEAPONTYPE_HEALING_STAFF] = 'heal',
		[WEAPONTYPE_BOW] = 'bow',
		[WEAPONTYPE_SHIELD] = 'shield'
	}
	if bar == 1 then
		if gear[2].link ~= 0 then endicon = icon[GetItemLinkWeaponType(gear[2].link)]
		else endicon = icon[GetItemLinkWeaponType(gear[1].link)] end
	else
		if gear[4].link ~= 0 then endicon = icon[GetItemLinkWeaponType(gear[4].link)]
		else endicon = icon[GetItemLinkWeaponType(gear[3].link)] end
	end
	if endicon then return 'AlphaGearX2/'..endicon..'.dds' else return nil end
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
			for set = 1,MAXSLOT do
				for _,x  in pairs(DUPSLOTS) do
					if(AG4.setdata[set].Gear[x].id == DRAGINFO.uid) then DRAGINFO.slot = {x}; break end
				end
			end
			AG4.SetCallout('Gear',1)
			invSlot:RegisterForEvent(EVENT_CURSOR_DROPPED, function() AG4.SetCallout('Gear',0) end)
		end
    end
end

function AG4.LoadItem(nr,slot,set)
	if not nr or not slot then return end
	if AG4.setdata[nr].Gear[slot].id ~= 0 then
		if Id64ToString(GetItemUniqueId(BAG_WORN,SLOTS[slot][1])) ~= AG4.setdata[nr].Gear[slot].id then
			local bagSlot = AG4.GetItemFromBag(AG4.setdata[nr].Gear[slot].id)
			if bagSlot then EquipItem(BAG_BACKPACK,bagSlot,SLOTS[slot][1])
			else d(ZOSF(L.NotFound,AG4.setdata[nr].Gear[slot].link)) end
		end
	elseif AG4.setdata[set].Set.lock == 1 then table.insert(GEARQUEUE,SLOTS[slot][1]) end
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
function AG4.LoadGear(nr,set)
	if not nr then return end
	for x = 1,14 do AG4.LoadItem(nr,x,set) end
end
function AG4.LoadSet(nr)
	if not nr then return end
	AG4.account.lastset = nr
	AG4.SwapMessage()
	local pair = GetActiveWeaponPairInfo()
	if AG4.setdata[nr].Set.gear > 0 then AG4.LoadGear(AG4.setdata[nr].Set.gear,nr) end
	if AG4.setdata[nr].Set.skill[pair] > 0 then AG4.LoadBar(AG4.setdata[nr].Set.skill[pair]) end
	SWAP = true
	-- AG4.UpdateCharge(nil,BAG_WORN)
	-- zo_callLater(AG4.SwapMessage,100)
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

function AG4.ScrollText()
	local function DrawControl(control)
		local container = ZO_ActionBar1:CreateControl('AG_SwapMessage'..control:GetNextControlId(),CT_CONTROL)
		local c = container:CreateControl('$(parent)Icon',CT_TEXTURE)
		c:SetAnchor(3,container,3,0,0)
		c:SetDimensions(64,64)
		container.c1 = c
		c = container:CreateControl('$(parent)Message',CT_LABEL)
		c:SetFont('AGFontBig')
		c:SetColor(1,0.66,0.2,1)
		c:SetAnchor(2,container.c1,8,5,0)
		container.c2 = c
		return container
	end
	local function ClearControl(c)
		c:SetHidden(true)
		c:ClearAnchors()
	end
	MESSAGE = ZO_ObjectPool:New(DrawControl,ClearControl)
end
function AG4.Slide(c,x)
	-- local ease = ZO_GenerateCubicBezierEase(1,0,.7,1.3)
	local ease = ZO_GenerateCubicBezierEase(.25,.5,.4,1.4)
    local a = ANIMATION_MANAGER:CreateTimeline()
    local s = a:InsertAnimation(ANIMATION_TRANSLATE,c)
    local fi = a:InsertAnimation(ANIMATION_ALPHA,c)
	local pos = GuiRoot:GetWidth()-x:GetRight()
    fi:SetAlphaValues(0,1)
    fi:SetDuration(150)
    s:SetStartOffsetX(pos)
    s:SetEndOffsetX(10+(x:GetRight()-ActionButton8:GetRight()))
    s:SetStartOffsetY(0)
    s:SetEndOffsetY(0)
    s:SetDuration(400)
	s:SetEasingFunction(ease)
	a:PlayFromStart()
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
	AG_RepairTex:SetColor(GetColor(condition,1))
	AG_RepairValue:SetText(condition..'%')
	AG_RepairValue:SetColor(GetColor(condition,1))
	AG_RepairCost:SetText(allcost..' |t12:12:esoui/art/currency/currency_gold.dds|t')
end
function AG4.UpdateCondition(_,bag,slot)
	if bag ~= BAG_WORN or slot == EQUIP_SLOT_COSTUME then return end
	local t, l = WM:GetControlByName('AG_InvBg'..slot), WM:GetControlByName('AG_InvBg'..slot..'Condition')
	local p = t:GetParent()
	p:SetMouseOverTexture(not ZO_Character_IsReadOnly() and 'AlphaGearX2/mo.dds' or nil)
	p:SetPressedMouseOverTexture(not ZO_Character_IsReadOnly() and 'AlphaGearX2/mo.dds' or nil)
	if GetItemInstanceId(BAG_WORN,slot) then
		if OPT[10] then
			t:SetHidden(false)
			t:SetColor(Quality(GetItemLink(BAG_WORN,slot),1))
		else t:SetHidden(true) end
		if OPT[9] and DoesItemHaveDurability(BAG_WORN,slot) then
			local con = GetItemCondition(BAG_WORN,slot)
			l:SetText(con..'%')
			l:SetColor(GetColor(con,0.9))
			l:SetHidden(false)
		else l:SetHidden(true) end
	else
		t:SetHidden(true)
		l:SetHidden(true)
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
		AG_Charge1Tex:SetTexture(w1)
		AG_Charge1Value:SetText(charge.."%")
		AG_Charge1Value:SetColor(GetColor(charge,1))
		AG_Charge1:SetHidden(false)
		if c1[1] < 1 and OPT[13] then
			local gem = AG4.GetSoulgem()
			if gem then
				ChargeItemWithSoulGem(BAG_WORN,g1,BAG_BACKPACK,gem)
				d(ZOSF(L.SoulgemUsed,GetItemName(BAG_WORN,g1)))
			end
		end
	else AG_Charge1:SetHidden(true) end
	if w2 then
		local charge = math.floor(c2[1]/c2[2]*100)
		AG_Charge2Tex:SetTexture(w2)
		AG_Charge2Value:SetText(charge.."%")
		AG_Charge2Value:SetColor(GetColor(charge,1))
		AG_Charge2:SetHidden(false)
		if c2[1] < 1 and OPT[13] then
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
	local text = 'text'
	for x = from, to do
		if AG4.setdata[x].Set.text[1] == 0 then text = 'Set '..x else text = AG4.setdata[x].Set.text[1] end
		local header, c = '|cFFAA33'..text..'|r', ''
		WM:GetControlByName('AG_SetSelector_'..x).data = { header = header, info = L.Set }
		WM:GetControlByName('AG_SetSelector_'..x..'KeyBind'):SetText(AG4.GetKey('AG4_SET_'..x))
		c = WM:GetControlByName('AG_SetSelector_'..x..'Box')
		c:SetText('  '..text)
	end
end
function AG4.UpdateEditPanel(nr)
	local val,set,c = nil, AG4.setdata[nr].Set
	SELECT = nr
	for x = 1,2 do
		for slot = 1,6 do
			if set.skill[x] > 0 then _,val = GetSkillAbilityInfo(unpack(AG4.setdata[set.skill[x]].Skill[slot])) else val = nil end
			WM:GetControlByName('AG_Edit_Skill_'..x..'_'..slot):SetNormalTexture(val)
		end
	end
	for slot = 1,14 do
		c = WM:GetControlByName('AG_Edit_Gear_1_'..slot)
		if set.gear > 0 and AG4.setdata[set.gear].Gear[slot].id ~= 0 then 
			c:SetNormalTexture(GetItemLinkInfo(AG4.setdata[set.gear].Gear[slot].link))
			c:GetNamedChild('Bg'):SetCenterColor(Quality(AG4.setdata[set.gear].Gear[slot].link,0.75))
		else
			c:SetNormalTexture('esoui/art/characterwindow/gearslot_'..SLOTS[slot][2]..'.dds')
			c:GetNamedChild('Bg'):SetCenterColor(0,0,0,0.2)
		end
	end
	if set.gear > 0 and AG4.setdata[set.gear].Gear[1].id ~= 0 then val = Zero(set.icon[1]) or AG4.GetSetIcon(set.gear,1) else val = 'x.dds' end
	AG_PanelSetPanelScrollChildEditPanelBar1IconTex:SetTexture(val)
	if set.gear > 0 and AG4.setdata[set.gear].Gear[3].id ~= 0 then val = Zero(set.icon[2]) or AG4.GetSetIcon(set.gear,2) else val = 'x.dds' end
	AG_PanelSetPanelScrollChildEditPanelBar2IconTex:SetTexture(val)

	if AG4.setdata[nr].Set.text[1] == 0 then val = '|cFFAA33Set '..nr..'|r' else val = '|cFFAA33'..val..'|r' end
	c = AG_PanelSetPanelScrollChildEditPanelGearConnector
	c:SetText(Zero(set.gear) or '')
	c.data = { header = val, info = L.SetConnector[1] }
	c = AG_PanelSetPanelScrollChildEditPanelBar1Connector
	c:SetText(Zero(set.skill[1]) or '')
	c.data = { header = val, info = L.SetConnector[2] }
	c = AG_PanelSetPanelScrollChildEditPanelBar2Connector
	c:SetText(Zero(set.skill[2]) or '')
	c.data = { header = val, info = L.SetConnector[3] }
	c = AG_PanelSetPanelScrollChildEditPanelGearLockTex
	if set.lock == 0 then c:SetTexture('AlphaGearX2/unlocked.dds') else c:SetTexture('AlphaGearX2/locked.dds') end
	AG_PanelSetPanelScrollChildEditPanelBar1NameEdit:SetText(Zero(set.text[2]) or 'Action-Bar 1')
	AG_PanelSetPanelScrollChildEditPanelBar2NameEdit:SetText(Zero(set.text[3]) or 'Action-Bar 2')
	WM:GetControlByName('AG_SetSelector_'..nr..'Edit'):SetText(Zero(set.text[1]) or 'Set '..nr)
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
	local col, p = {'green','grey'}, {'Skill','Skill','Gear'}
	for nr = 1, MAXSLOT do
		WM:GetControlByName('AG_Selector_'..p[parent]..'_'..nr):SetNormalTexture('AlphaGearX2/'..col[mode]..'.dds')
	end
end
function AG4.SetConnection(c,button)
	local name, mode = {string.match(c:GetName(),'(%a+)(%d)Connector')}
	mode = tonumber(name[2]) or 3
	SELECTBAR = mode
	if button == 1 then
		AG4.SetConnect(mode,1)
	elseif button == 2 then
		if mode < 3 then AG4.setdata[SELECT].Set.skill[SELECTBAR] = 0
		else AG4.setdata[SELECT].Set.gear = 0 end
	end
	AG4.UpdateEditPanel(SELECT)
end
function AG4.SetSetLock()
	if SELECT then
		local set,c = AG4.setdata[SELECT].Set
		c = AG_PanelSetPanelScrollChildEditPanelGearLockTex
		if set.lock == 0 then
			set.lock = 1
			c:SetTexture('AlphaGearX2/locked.dds')
		else
			set.lock = 0
			c:SetTexture('AlphaGearX2/unlocked.dds')
		end
	end
end
function AG4.SetSetName(mode,text)
	if not mode or not text then return end
	if SELECT then AG4.setdata[SELECT].Set.text[mode] = text end
end
function AG4.SetOptions()
	AG_Repair:SetHidden(not OPT[3])
	AG_RepairCost:SetHidden(not OPT[4])
	if OPT[3] then
		EM:RegisterForEvent('AG_Event_Repair',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateRepair)
		AG4.UpdateRepair(nil,BAG_WORN)
	else EM:UnregisterForEvent('AG_Event_Repair',EVENT_INVENTORY_SINGLE_SLOT_UPDATE) end
	
	AG_Charge1:SetHidden(not OPT[5])
	AG_Charge2:SetHidden(not OPT[5])
	if OPT[5] then
		EM:RegisterForEvent('AG_Event_Charge',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateCharge)
		AG4.UpdateCharge(nil,BAG_WORN)
	else EM:UnregisterForEvent('AG_Event_Charge',EVENT_INVENTORY_SINGLE_SLOT_UPDATE) end

	if OPT[9] then
		EM:RegisterForEvent('AG_Event_Condition',EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AG4.UpdateCondition)
		for _,c in pairs(SLOTS) do AG4.UpdateCondition(_,BAG_WORN,c[1]) end
	else
		EM:UnregisterForEvent('AG_Event_Condition',EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
		for _,c in pairs(SLOTS) do AG4.UpdateCondition(_,BAG_WORN,c[1]) end
	end
	
	if OPT[11] then EM:RegisterForEvent('AG_Event_Movement',EVENT_NEW_MOVEMENT_IN_UI_MODE, function() AG_Panel:SetHidden(true) end)
	else EM:UnregisterForEvent('AG_Event_Movement',EVENT_NEW_MOVEMENT_IN_UI_MODE) end

	if not OPT[7] then if FUNC2 then MESSAGE:ReleaseObject(FUNC2) end end
	AG_UI_Button:SetHidden(not OPT[1])
	AG_UI_ButtonBg:SetHidden(not OPT[1])
	AG_UI_ButtonBg:SetMouseEnabled(not OPT[12])
	AG_UI_ButtonBg:SetMovable(not OPT[12])
	AG_SetButtonFrame:SetHidden(not OPT[2])
	AG_SetButtonBg:SetHidden(not OPT[2])
	AG_SetButtonBg:SetMouseEnabled(not OPT[12])
	AG_SetButtonBg:SetMovable(not OPT[12])
end
function AG4.SetPosition(parent,pos)
	AG_Panel:ClearAnchors()
	AG_Panel:SetAnchor(8,parent,2,pos,0)
	AG_SetButtonFrame:SetHidden(true)
	ZO_ActionBar1:GetChild(ZO_ActionBar1:GetNumChildren()):SetHidden(true)
end

function AG4.ResetPosition()
	AG_Panel:ClearAnchors()
	AG_Panel:SetAnchor(3,GuiRoot,3,AG4.account.pos[1],AG4.account.pos[2])
	AG_SetButtonFrame:SetHidden(not OPT[2])
	AG_UI_ButtonBg:ClearAnchors()
	AG_UI_ButtonBg:SetAnchor(3,GuiRoot,3,AG4.account.button[1],AG4.account.button[2])
	AG_SetButtonBg:ClearAnchors()
	AG_SetButtonBg:SetAnchor(3,AG_Charge1,3,AG4.account.setbuttons[1],AG4.account.setbuttons[2])
	ZO_ActionBar1:GetChild(ZO_ActionBar1:GetNumChildren()):SetHidden(not OPT[7])
end
function AG4.ShowIconMenu(c,bar)
	AG_PanelIcons:SetAnchor(6,c,12,0,0)
	AG_PanelIcons:ToggleHidden()
	if not AG_PanelIcons:IsHidden() then
		for x = 1,AG_PanelIconsScrollChild:GetNumChildren() do AG_PanelIconsScrollChild:GetChild(x):SetHidden(true) end
		local xpos,ypos,name,c = 10, 10
		for x,icon in pairs(ICON) do
			name = 'AG_SetIcon_'..x
			c = WM:GetControlByName(name)
			if not c then
				c = WM:CreateControl(name,AG_PanelIconsScrollChild,CT_BUTTON)
				c:SetAnchor(3,AG_PanelIconsScrollChild,3,xpos,ypos)
				c:SetDimensions(64,64)
				c:SetClickSound('Click')
				c:SetMouseOverTexture('AlphaGearX2/light.dds')
				c:SetHandler('OnClicked',function(self)
					if SELECT > 0 then
						AG4.setdata[SELECT].Set.icon[bar] = icon
						AG_PanelIcons:SetHidden(true)
						AG4.UpdateEditPanel(SELECT)
					end
				end)
				if x%3 == 0 then xpos = 10; ypos = ypos + 69
				else xpos = xpos + 69 end
			end
			c:SetNormalTexture(icon)
			c:SetHidden(false)
		end
		AG_PanelIconsScrollChild:SetHeight(math.ceil(#ICON/3)*69+10)
	end
end
function AG4.ShowButton(c)
	if not c then return false end
	local type, nr, slot = AG4.GetButton(c)
	local skill, gear = AG4.setdata[nr].Skill, AG4.setdata[nr].Gear
	if type == 'Skill' then
		if skill[slot][1] ~= 0 then
			local _,icon = GetSkillAbilityInfo(unpack(skill[slot]))
			c:SetNormalTexture(icon)
			c.data = { hint = '\n'..L.Button[type] }
		else
			c:SetNormalTexture()
			c.data = nil
		end
	else
		if gear[slot].link ~= 0 then
			c:SetNormalTexture(GetItemLinkInfo(gear[slot].link))
			c:GetNamedChild('Bg'):SetCenterColor(Quality(gear[slot].link,0.75))
			c.data = { hint = '\n'..L.Button[type] }
		else
			c:SetNormalTexture('esoui/art/characterwindow/gearslot_'..SLOTS[slot][2]..'.dds')
			c:GetNamedChild('Bg'):SetCenterColor(0,0,0,0.2)
			c.data = nil
		end
	end
	if SELECT and not AG_PanelSetPanelScrollChildEditPanel:IsHidden() then
		if (nr == AG4.setdata[SELECT].Set.gear or nr == AG4.setdata[SELECT].Set.skill[1] or nr == AG4.setdata[SELECT].Set.skill[2])
		then AG4.UpdateEditPanel(nr) end
	end
end
function AG4.ShowMain()
	SM:ToggleTopLevel(AG_Panel)
	if not AG_Panel:IsHidden() then AG4.UpdateUI() end
end
function AG4.SwapMessage()
	if OPT[6] then
		local pair,x,tex,set = GetActiveWeaponPairInfo()
		set = AG4.setdata[AG4.account.lastset].Set
		if FUNC2 then MESSAGE:ReleaseObject(FUNC2) end
		FUNC1,FUNC2 = MESSAGE:AcquireObject()
		FUNC1:SetHidden(false)
		x = ActionButton8
		if not AG_Repair:IsHidden() then x = AG_Repair end
		if not AG_Charge1:IsHidden() then x = AG_Charge1 end
		if not AG_Charge2:IsHidden() then x = AG_Charge2 end
		if set.gear ~= 0 then
			if AG4.setdata[set.gear].Gear[pair+(1+pair)].id ~= 0 then
				tex = Zero(set.icon[pair]) or AG4.GetSetIcon(set.gear,pair)
			else tex = 'AlphaGearX2/nothing.dds' end
		end
		FUNC1:SetAnchor(3,ActionButton8,9,0,0)
		FUNC1:GetChild(1):SetTexture(tex)
		FUNC1:GetChild(2):SetText('Nr: '..AG4.account.lastset..' - '..(set.text[1] or 'Set '..AG4.account.lastset)..'\n|cFFFFFF'..(set.text[pair + 1] or 'Action-Bar '..pair))
		AG4.Slide(FUNC1,x)
		if not OPT[7] then
			EM:RegisterForUpdate('AG_SwapCounter', 2000, function()
				if FUNC2 then
					MESSAGE:ReleaseObject(FUNC2)
					EM:UnregisterForUpdate('AG_SwapCounter')
				end
			end)
		end
	end
end
function AG4.Swap(_,isSwap)
    if isSwap and not IsBlockActive()then
		if AG4.account.lastset and SWAP then
			local pair = GetActiveWeaponPairInfo()
			if AG4.setdata[AG4.account.lastset].Set.skill[pair] > 0 then AG4.LoadBar(AG4.setdata[AG4.account.lastset].Set.skill[pair]) end
			SWAP = false
		end
		AG4.UpdateCharge(nil,BAG_WORN)
		AG4.SwapMessage()
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
	end
end
function AG4.Tooltip(c,visible,edit)
	local function FadeIn(control)
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
			if edit then nr = AG4.setdata[SELECT].Set.gear end
			if nr > 0 then
				if AG4.setdata[nr].Gear[slot].link == 0 then return end
				c.text = ItemTooltip
				InitializeTooltip(c.text,AG_Panel,3,0,0,9)
				c.text:SetLink(AG4.setdata[nr].Gear[slot].link)
				ZO_ItemTooltip_ClearCondition(c.text)
				ZO_ItemTooltip_ClearCharges(c.text)
			else return end
		elseif type == 'Skill' then
			if edit then nr = AG4.setdata[SELECT].Set.skill[nr] end
			if nr > 0 then
				if AG4.setdata[nr].Skill[slot][1] == 0 then return end
				c.text = SkillTooltip
				InitializeTooltip(c.text,AG_Panel,3,0,0,9)
				c.text:SetSkillAbility(AG4.setdata[nr].Skill[slot][1], AG4.setdata[nr].Skill[slot][2], AG4.setdata[nr].Skill[slot][3])
			else return end
		elseif c.data and c.data.tip then
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
function AG4.TooltipSet(nr,visible)
	if not nr then return end
	if visible then
		local set,val = AG4.setdata[nr].Set
		for z = 1,2 do
			local ico = ''
			for x = 1,6 do
				if set.skill[z] > 0 and AG4.setdata[set.skill[z]].Skill[x][1] ~= 0 then
					_,val = GetSkillAbilityInfo(unpack(AG4.setdata[set.skill[z]].Skill[x]))
				else val = 'AlphaGearX2/grey1.dds' end
				ico = ico..'|t36:36:'..val..'|t '
			end
			WM:GetControlByName('AG_SetTipBar'..z..'Skills'):SetText(ico)
			if set.gear ~= 0 then
				val = Zero(set.icon[z]) or AG4.GetSetIcon(set.gear,z)
			else val = 'AlphaGearX2/nothing.dds' end
			WM:GetControlByName('AG_SetTipSkill'..z..'Icon'):SetTexture(val)
		end
		AG_SetTipName:SetText(Zero(set.text[1]) or 'Set '..nr)
		AG_SetTipBar1Name:SetText(Zero(set.text[2]) or 'Action-Bar 1')
		AG_SetTipBar2Name:SetText(Zero(set.text[3]) or 'Action-Bar 2')
		AG_SetTip:ClearAnchors()
		AG_SetTip:SetAnchor(6,AG_UI_SetButton_1,3,0,-2)
		AG_SetTip:SetHidden(false)
	else AG_SetTip:SetHidden(true) end
end
function AG4.TooltipShow(c,id)
	if OPT[8] and id then
		local sets = 'test'
		-- for x,set in pairs(AG4.setdata) do
			-- if set.Set.gear ~= 0 then
				-- for _,slot in pairs(set.gear[set.Set.gear]) do
					-- if slot.id == id then
						-- sets = sets..x..' '
						-- break
					-- end
				-- end
			-- end
		-- end
		if sets ~= '' then c:AddLine(ZOSF(L.SetPart,sets),"ZoFontGameSmall") end
	end
end
function AG4.TooltipHandle()
	local tt = ItemTooltip.SetBagItem
	ItemTooltip.SetBagItem = function(c,bag,slot,...)
		tt(c,bag,slot,...)
		AG4.TooltipShow(c,Id64ToString(GetItemUniqueId(bag,slot)))
	end
end

function KEYBINDING_MANAGER:IsChordingAlwaysEnabled() return true end
function AlphaGear_RegisterIcon(icon) table.insert(ICON,icon or 'AlphaGearX2/nothing.dds') end

EM:RegisterForEvent('AG4',EVENT_ADD_ON_LOADED,function(_,name)
	if name ~= AG4.name then return end
	SM:RegisterTopLevel(AG_Panel,false)
    EM:UnregisterForEvent('AG4',EVENT_ADD_ON_LOADED)
	EM:RegisterForEvent('AG4',EVENT_ACTION_SLOTS_FULL_UPDATE, AG4.Swap)

	local init_account = {
		option = {true,true,true,true,true,true,true,true,true,true,true,false,true},
		pos = {GuiRoot:GetWidth()/2 - 335, GuiRoot:GetHeight()/2 - 410},
		button = {50,100},
		setbuttons = {0,-80},
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
	AG4.setdata = ZO_SavedVars:New('AGX2_Character',1,nil,init_data)
	AG4.account = ZO_SavedVars:NewAccountWide('AGX2_Account',1,nil,init_account)
	ZO_CreateStringId('SI_BINDING_NAME_SHOW_AG_WINDOW', 'AlphaGearX2')
	ZO_CreateStringId('SI_BINDING_NAME_AG4_UNDRESS', 'Unequip all Armor')
	OPT = AG4.account.option
	for x = 1, MAXSLOT do
		ZO_CreateStringId('SI_BINDING_NAME_AG4_SET_'..x, 'Load Set '..x)
		AG4.DrawSet(x)
		AG4.DrawButtonLine(1,x)
		AG4.DrawButtonLine(2,x)
	end
	for x = 1,3 do
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelSkill11Box,'Edit','Skill',1,x,42*(x-1),0,true)
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelSkill12Box,'Edit','Skill',1,x+3,42*(x-1),0,true)
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelSkill21Box,'Edit','Skill',2,x,42*(x-1),0,true)
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelSkill22Box,'Edit','Skill',2,x+3,42*(x-1),0,true)
	end
	for x = 1,2 do
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelWeap1Box,'Edit','Gear',1,x,0,42*(x-1),true)
		AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelWeap2Box,'Edit','Gear',1,x+2,0,42*(x-1),true)
	end
	for x = 5,9 do AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelGear1Box,'Edit','Gear',1,x,42*(x-5),0,true) end
	for x = 10,14 do AG4.DrawButton(AG_PanelSetPanelScrollChildEditPanelGear2Box,'Edit','Gear',1,x,42*(x-10),0,true) end

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
	ZO_PreHookHandler(AG_Panel,'OnHide', function() AG_PanelIcons:SetHidden(true); AG_PanelOptionPanel:SetHidden(true) end)
	
	AG_PanelIcons.useFadeGradient = false
	AG_PanelSetPanel.useFadeGradient = false
	AG_PanelGearPanel.useFadeGradient = false
	AG_PanelSkillPanel.useFadeGradient = false

	AG_UI_Button.data = { tip = AG4.name }
	AG_PanelSetPanelScrollChildEditPanelGearLock.data = { info = L.Lock }
	
	AG4.DrawSetButtonsUI()
	AG4.DrawInventory()
	AG4.DrawOptions()
	AG4.ResetPosition()
	-- AG4.TooltipHandle()
	AG4.SetOptions()
	AG4.ScrollText()
	
	AlphaGear_RegisterIcon('AlphaGearX2/onehand.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/twohand.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/fire.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/frost.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/shock.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/heal.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/bow.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/shield.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/power.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/bonehead.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/training.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/wolf.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/vampire.dds')
	AlphaGear_RegisterIcon('AlphaGearX2/horse.dds')
	
	SELECT = AG4.account.lastset
	AG4.init = true
end)
