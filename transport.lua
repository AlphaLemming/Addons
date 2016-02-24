local function Zero(val) if val == 0 then return nil else return val end end

function AG4.GetSetIcon(nr,bar)
	local endicon,gear,icon = nil, AG4.setdata[nr].Gear, {
		[WEAPONTYPE_NONE] = 'none',
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

function AG4.TooltipSet(c,nr,visible)
	if not c or not nr then return end
	if visible then
		local set,val = AG4.setdata[nr].Set
		if set.Set.gear ~= 0 then
			val = Zero(set.icon[1]) or AG4.GetSetIcon(set.gear,1)
		else val = 'AlphaGearX2/none.dds' end
		AG_SetTipSkill1Icon:SetTexture(val)
		if set.Set.gear ~= 0 then
			val = Zero(set.icon[2]) or AG4.GetSetIcon(set.gear,2)
		else val = 'AlphaGearX2/none.dds' end
		AG_SetTipSkill2Icon:SetTexture(val)
		AG_SetTipName:SetText(Zero(set.text[1]) or 'Set '..nr)
		AG_SetTipBar1Name:SetText(Zero(set.text[2]) or 'Action-Bar 1')
		AG_SetTipBar2Name:SetText(Zero(set.text[3]) or 'Action-Bar 2')
		for x = 1,6 do
			if AG4.setdata[set.Set.skill[1]].Skill[x][1] ~= 0 then
				_,val = GetSkillAbilityInfo(unpack(AG4.setdata[set.Set.skill[1]].Skill[x]))
			else val = 'AlphaGearX2/grey1.dds' end
		end
		AG_SetTipBar1Skills:SetText('|t40:40:'..val..'|t ')
		for x = 1,6 do
			if AG4.setdata[set.Set.skill[2]].Skill[x][1] ~= 0 then
				_,val = GetSkillAbilityInfo(unpack(AG4.setdata[set.Set.skill[2]].Skill[x]))
			else val = 'AlphaGearX2/grey1.dds' end
		end
		AG_SetTipBar2Skills:SetText('|t40:40:'..val..'|t ')
		AG_SetTip:SetAnchor(6,c,3,0,-2)
		AG_SetTip:SetHidden(false)
	else AG_SetTip:SetHidden(true) end
end
function AG4.DrawSetButtonsUI()
	local xpos,ypos,c = 10,10
	for x = 1,MAXSLOT do
		c = WM:CreateControl('AG_UI_SetButton_'..x, AG_SetButtonFrame, CT_BUTTON)
		c:SetAnchor(3,AG_SetButtonFrame,3,xpos,ypos)
		c:SetDimensions(20,20)
		c:SetHorizontalAlignment(1)
		c:SetVerticalAlignment(1)
		c:SetClickSound('Click')
		c:SetFont('AGFont')
		c:SetColor(1,1,1,1)
		c:SetText(x)
		c:SetNormalTexture('AlphaGearX2/grey.dds')
		c:SetMouseOverTexture('AlphaGearX2/light.dds')
		c:SetHandler('OnMouseEnter',function(self) AG4.TooltipSet(self,x,true) end)
		c:SetHandler('OnMouseExit',function(self) AG4.TooltipSet(self,x,false) end)
		c:SetHandler('OnClicked',function(self) AG4.LoadSet(x) end)
		if x == MAXLOTS/2 then ypos = ypos + 25; xpos = 10
		else xpos = xpos + 5 end
	end
end
function AG4.UpdateEditPanel(nr)
	local val,set,gear,skill,c = nil, AG4.setdata[nr].Set, AG4.setdata[nr].Gear, AG4.setdata[nr].Skill 
	SELECT = nr
	for x = 1,2 do
		for slot = 1,6 do
			if set.skill[x] > 0 then _,val = GetSkillAbilityInfo(unpack(skill[slot])) else val = nil end
			WM:GetControlByName('AG_Edit_Skill_'..x..'_'..slot):SetNormalTexture(val)
		end
	end
	for slot = 1,14 do
		c = WM:GetControlByName('AG_Edit_Gear_1_'..slot)
		if set.gear > 0 and gear[slot].id ~= 0 then 
			c:SetNormalTexture(GetItemLinkInfo(gear[slot].link))
			c:GetNamedChild('Bg'):SetCenterColor(unpack(QUALITY[GetItemLinkQuality(gear[slot].link)]),0.75)
		else
			c:SetNormalTexture('esoui/art/characterwindow/gearslot_'..SLOTS[slot][2]..'.dds')
			c:GetNamedChild('Bg'):SetCenterColor(0,0,0,0.2)
		end
	end
	if set.gear > 0
		if AG4.setdata[set.gear].Gear[1].id ~= 0 then
			val = Zero(set.icon[1]) or AG4.GetSetIcon(set.gear,1)
		end
	else val = 'x.dds' end
	AG_PanelSetPanelScrollChildEditPanelBar1IconTex:SetTexture(val)
	if set.gear > 0
		if AG4.setdata[set.gear].Gear[3].id ~= 0 then
			val = Zero(set.icon[2]) or AG4.GetSetIcon(set.gear,2)
		end
	else val = 'x.dds' end
	AG_PanelSetPanelScrollChildEditPanelBar2IconTex:SetTexture(val)

	if AG4.setdata[nr].Set.text[1] == 0 then val = '|cFFAA33Set '..nr..'|r' else val = '|cFFAA33'..val..'|r' end
	c = AG_PanelSetPanelScrollChildEditPanelGearConnector
	c.SetText(Zero(set.gear) or '')
	c.data = { header = val, info = L.SetConnector[1] }
	c = AG_PanelSetPanelScrollChildEditPanelBar1Connector
	c.SetText(Zero(set.skill[1]) or '')
	c.data = { header = val, info = L.SetConnector[2] }
	c = AG_PanelSetPanelScrollChildEditPanelBar2Connector
	c.SetText(Zero(set.skill[2]) or '')
	c.data = { header = val, info = L.SetConnector[3] }
	c = AG_PanelSetPanelScrollChildEditPanelGearLockTex
	if set.lock == 0 then c:SetTexture('AlphaGearX2/unlocked.dds') else c:SetTexture('AlphaGearX2/locked.dds') end
	AG_PanelSetPanelScrollChildEditPanelBar1NameEdit:SetText(Zero(set.text[2]) or 'Action-Bar 1')
	AG_PanelSetPanelScrollChildEditPanelBar2NameEdit:SetText(Zero(set.text[3]) or 'Action-Bar 2')
	WM:GetControlByName('AG_SetSelector_'..nr..'Edit'):SetText(Zero(set.text[1]) or 'Set '..nr)
end

local QUALITY = {[0]={0.65,0.65,0.65},[1]={1,1,1},[2]={0.17,0.77,0.05},[3]={0.22,0.57,1},[4]={0.62,0.18,0.96},[5]={0.80,0.66,0.10}}

Bezir: .25,.5,.4,1.4

ToDo:

UI Set Buttons + Positioning and Tooltip
Set Gear Connector clearout
Item + Skill Tooltip Hint
Dragging issue
Edit Panel Update on skill drag
Swap Message on Set Load
Icons on empty sets
