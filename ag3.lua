--[[
AlphaGear - Copyright (c) 2015 Andreas Mennel (@AlphaLemming)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

DISCLAIMER:

This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc.
or its affiliates. The Elder Scrolls® and related logos are registered trademarks
or trademarks of ZeniMax Media Inc. in the United States and/or other countries.
All rights reserved.

You can read the full terms at: https://account.elderscrollsonline.com/add-on-terms
]]
local EM,WM,control,row,IM,BG=EVENT_MANAGER,WINDOW_MANAGER,1,1,{},{}
local TAL,TAR,TAC=TEXT_ALIGN_LEFT,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER
AG={}
AG.name,AG.version="AlphaGear","3.07"
AG.language=GetCVar("language.2")
AG.PLAYER,AG.SET,AG.BAR,AG.SELECT,AG.INIT,AG.ABAR,AG.LASTCID=zo_strformat('<<C:1>>',GetUnitName('player')),1,1,false,false,nil,nil
AG.GEARQUEUE,AG.CHARGE1,AG.CHARGE2,AG.gearbtn,AG.skillbtn,AG.setbtn,AG.uiBtn,AG.costume={},nil,nil,{},{},{},{},{}
AG.images={"1","2","3","4","5","6","7","8","a","b","c"}
AG.splash={"11","21","31","41","51","61","71","81","a1","b1","c1"}
AG.color={
	[0]={0.76,0.76,0.76,1},
	[1]={1,1,1,1},
	[2]={0.18,0.77,0.06,1},
	[3]={0.23,0.57,1,1},
	[4]={0.63,0.18,0.97,1},
	[5]={0.93,0.79,0.16,1},
	[10]="C3C3C3",
	[11]="FFFFFF",
	[12]="2DC50E",
	[13]="3A92FF",
	[14]="A02EF7",
	[15]="EECA2A"
}
AG.gearslot={
	EQUIP_SLOT_HEAD,
	EQUIP_SLOT_CHEST,
	EQUIP_SLOT_LEGS,
	EQUIP_SLOT_SHOULDERS,
	EQUIP_SLOT_FEET,
	EQUIP_SLOT_WAIST,
	EQUIP_SLOT_HAND,
	EQUIP_SLOT_COSTUME,
	EQUIP_SLOT_NECK,
	EQUIP_SLOT_RING1,
	EQUIP_SLOT_RING2,
	EQUIP_SLOT_MAIN_HAND,
	EQUIP_SLOT_OFF_HAND,
	EQUIP_SLOT_BACKUP_MAIN,
	EQUIP_SLOT_BACKUP_OFF,
}
AG.icon={
	[EQUIP_SLOT_HEAD]="head.dds",
	[EQUIP_SLOT_NECK]="neck.dds",
	[EQUIP_SLOT_CHEST]="chest.dds",
	[EQUIP_SLOT_SHOULDERS]="shoulders.dds",
	[EQUIP_SLOT_MAIN_HAND]="mainhand.dds",
	[EQUIP_SLOT_OFF_HAND]="offhand.dds",
	[EQUIP_SLOT_WAIST]="belt.dds",
	[EQUIP_SLOT_HAND]="hands.dds",
	[EQUIP_SLOT_LEGS]="legs.dds",
	[EQUIP_SLOT_FEET]="feet.dds",
	[EQUIP_SLOT_COSTUME]="costume.dds",
	[EQUIP_SLOT_RING1]="ring.dds",
	[EQUIP_SLOT_RING2]="ring.dds",
	[EQUIP_SLOT_BACKUP_MAIN]="mainhand.dds",
	[EQUIP_SLOT_BACKUP_OFF]="offhand.dds"
}
function AG.DrawScreen(arg)
	local c=WM:CreateTopLevelWindow(arg.name)
	if arg.mouse then c:SetMouseEnabled(true)end
	if arg.move then c:SetMovable(true)end
	c:SetHidden(true)
	if arg.anchor then c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])
	else c:SetAnchor(CENTER,GuiRoot,CENTER,0,0)end
	if arg.size then c:SetDimensions(arg.size[1],arg.size[2]) else c:SetDimensions(100,100)end
	if arg.layer then c:SetDrawLayer(arg.layer)end
	if arg.bg~=false then
		local b=WM:CreateControl(arg.name.."Bg",c,CT_BACKDROP)
		b:SetEdgeColor(0,0,0,1)
		b:SetEdgeTexture("",1,1,1)
		b:SetCenterColor(0.1,0.1,0.1,0.95)
		if arg.size then b:SetDimensions((arg.size[1]+10),(arg.size[2]+10))
		else b:SetDimensions(115,115)end
		b:SetAnchor(CENTER,c,CENTER,0,0)
	end
end
function AG.DrawSplash()
	local c=WM:CreateTopLevelWindow("AG_SplashBg")
	c:SetHidden(true)
	c:SetAnchor(TOP,GuiRoot,TOP,0,90)
	c:SetDimensions(128,128)
	local a=WM:CreateControl("AG_Splash",c,CT_TEXTURE)
	a:SetColor(1,1,1,1)
	a:SetAnchorFill()
end
function AG.DrawLabel(arg)
	local n,p=arg.name or "AG_Control"..control,arg.parent or AG_Screen
	local c=WM:CreateControl(n,p,CT_LABEL)
	if arg.text then
		c:SetText(arg.text)
		if arg.halign then c:SetHorizontalAlignment(arg.halign)end
		if arg.valign then c:SetVerticalAlignment(arg.valign)end
		if arg.font then c:SetFont(arg.font)else c:SetFont("ZoFontGame")end
		if arg.color then c:SetColor(arg.color[1],arg.color[2],arg.color[3],arg.color[4])
		else c:SetColor(1,1,1,1)end
	end
	if arg.full then c:SetAnchorFill()else
	if arg.anchor then c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])else c:SetAnchor(CENTER,p,CENTER,0,0)end
	if arg.size then c:SetDimensions(arg.size[1],arg.size[2])end
	end
	if arg.layer then c:SetDrawLayer(arg.layer) end
	control=control+1
	return c
end
function AG.DrawOption(arg)
	local n,p=arg.name or "AG_Control"..control,arg.parent or AG_Screen
	local c=WM:CreateControl(n,p,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	if arg.tooltip then
		c.data={tooltipText=arg.tooltip}
		c:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
		c:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
	end
	c:SetNormalTexture("esoui/art/buttons/decline_up.dds")
	c:SetMouseOverTexture("esoui/art/buttons/decline_over.dds")
	if arg.anchor then c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])
	else c:SetAnchor(CENTER,p,CENTER,0,0)end
	if arg.size then c:SetDimensions(arg.size[1],arg.size[2])else c:SetDimensions(25,25)end
	c:SetClickSound("Click")
	if arg.func then c:SetHandler("OnClicked",function(self,...)arg.func(self,...)end)end
	control=control+1
	return c
end
function AG.DrawButton(arg)
	local n,p=arg.name or "AG_Control"..control,arg.parent or AG_Screen
	local c=WM:CreateControl(n,p,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	if arg.tooltip then
		c.data={tooltipText=arg.tooltip}
		c:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
		c:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
	end
	if arg.enter then c:SetHandler("OnMouseEnter",function(self,...)arg.enter(self,...)end)end
	if arg.leave then c:SetHandler("OnMouseExit",function(self,...)arg.leave(self,...)end)end
	if arg.text then
		c:SetText(arg.text)
		if arg.halign then c:SetHorizontalAlignment(arg.halign) end
		if arg.valign then c:SetVerticalAlignment(arg.valign) end
		if arg.font then c:SetFont(arg.font)else c:SetFont("ZoFontGame")end
		if arg.color then c:SetNormalFontColor(arg.color[1],arg.color[2],arg.color[3],arg.color[4])else c:SetNormalFontColor(1,1,1,1)end
		if arg.colorHover then c:SetMouseOverFontColor(arg.colorHover[1],arg.colorHover[2],arg.colorHover[3],arg.colorHover[4])end
	end
	if arg.icon then c:SetNormalTexture(arg.icon)end
	if arg.iconHover then c:SetMouseOverTexture(arg.iconHover)end
	if arg.full then c:SetAnchorFill()else
		if arg.anchor then c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])else c:SetAnchor(CENTER,p,CENTER,0,0)end
		if arg.size then c:SetDimensions(arg.size[1],arg.size[2])else c:SetDimensions(25,25)end
	end
	if arg.func then
		c:SetClickSound("Click")
		c:SetHandler("OnClicked",function(self,...)arg.func(self,...)end)
	end
	if arg.layer then c:SetDrawLayer(arg.layer) end
	control=control+1
	return c
end
function AG.DrawBackdrop(arg)
	local n,p=arg.name or "AG_Control"..control,arg.parent or AG_Screen
	local c=WM:CreateControl(n,p,CT_BACKDROP)
	if arg.mouse then c:SetMouseEnabled(true)end
	if arg.move then c:SetMovable(true)end
	c:SetEdgeColor(1,1,1,0)
	c:SetCenterColor(0,0,0,0)
	if arg.full then c:SetAnchorFill()else
		if arg.anchor then c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])else c:SetAnchor(CENTER,p,CENTER,0,0)end
		if arg.size then c:SetDimensions(arg.size[1],arg.size[2])else c:SetDimensions(25,25)end
	end
	if arg.layer then c:SetDrawLayer(arg.layer) end
	control=control+1
	return c
end
function AG.DrawTTFrame()
	local c=WM:CreateControl("AG_TTFrame",AG_ButtonFrame,CT_BACKDROP)
	c:SetAnchor(BOTTOMLEFT,AG_ButtonFrame,TOPLEFT,0,5)
	c:SetEdgeColor(0,0,0,0)
	c:SetCenterColor(0,0,0,0.2)
	c:SetDimensions(250,81)
	c:SetHidden(true)
	local b=WM:CreateControlFromVirtual("AG_TTbg",c,"ZO_DefaultBackdrop")
	b:SetAnchorFill()
	local a=WM:CreateControl("AG_TTPic1",c,CT_TEXTURE)
	a:SetDimensions(45,45)
	a:SetAnchor(TOPLEFT,c,TOPLEFT,5,28)
	a=WM:CreateControl("AG_TTPic2",c,CT_TEXTURE)
	a:SetDimensions(45,45)
	a:SetAnchor(TOPLEFT,c,TOPLEFT,55,28)
	a=WM:CreateControl("AG_TTHead",c,CT_LABEL)
	a:SetDimensions(100,18)
	a:SetAnchor(TOPLEFT,c,TOPLEFT,10,5)
	a:SetHorizontalAlignment(TAL)
	a:SetFont("ZoFontWinH4")
	a:SetColor(1,0.6,0.3,1)
	for x=1,6 do
		AG.uiBtn[x]=WM:CreateControl("AG_TTIcon1"..x,c,CT_TEXTURE)
		AG.uiBtn[x]:SetDimensions(20,20)
		AG.uiBtn[x]:SetAnchor(TOPLEFT,c,TOPLEFT,105+(x-1)*22,28)
	end
	for x=7,12 do
		AG.uiBtn[x]=WM:CreateControl("AG_TTIcon2"..x,c,CT_TEXTURE)
		AG.uiBtn[x]:SetDimensions(20,20)
		AG.uiBtn[x]:SetAnchor(TOPLEFT,c,TOPLEFT,105+(x-7)*22,50)
	end
end
function AG.DrawUIButton(nr,x,y)
	local b=WM:CreateControl("AG_ButtonBg"..nr,AG_ButtonFrame,CT_BACKDROP)
	b:SetDimensions(24,24)
	b:SetAnchor(TOPLEFT,AG_ButtonFrame,TOPLEFT,10+x,10+y)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterColor(0.4,0.4,0.4,0.8)
	b:SetCenterTexture("AlphaGear/icon/button.dds")
	local c=WM:CreateControl("AG_Button"..nr,b,CT_BUTTON)
	c:SetAnchorFill()
	c:SetState(BSTATE_NORMAL)
	c.text=nil
	c:SetHandler("OnMouseEnter",function(self)
		AG_TTPic1:SetTexture('esoui/art/actionbar/abilityinset.dds')
		AG_TTPic2:SetTexture('esoui/art/actionbar/abilityinset.dds')
		for x=1,12 do AG.uiBtn[x]:SetTexture('esoui/art/actionbar/abilityinset.dds')end
		if AG.setdata.set[nr]then AG_TTHead:SetText("SET "..nr)end
		if AG.setdata.set[nr].bar[1]then
			if AG.images[AG.setdata.set[nr].pic[1]]then AG_TTPic1:SetTexture("AlphaGear/icon/"..AG.images[AG.setdata.set[nr].pic[1]]..".dds")end
			for x=1,6 do
				local _,icon=GetSkillAbilityInfo(AG.setdata.skill[AG.setdata.set[nr].bar[1]][x][1],AG.setdata.skill[AG.setdata.set[nr].bar[1]][x][2],AG.setdata.skill[AG.setdata.set[nr].bar[1]][x][3])
				AG.uiBtn[x]:SetTexture(icon)
			end
		end
		if AG.setdata.set[nr].bar[2]then
			if AG.images[AG.setdata.set[nr].pic[2]]then AG_TTPic2:SetTexture("AlphaGear/icon/"..AG.images[AG.setdata.set[nr].pic[2]]..".dds")end
			for x=1,6 do
				local _,icon=GetSkillAbilityInfo(AG.setdata.skill[AG.setdata.set[nr].bar[2]][x][1],AG.setdata.skill[AG.setdata.set[nr].bar[2]][x][2],AG.setdata.skill[AG.setdata.set[nr].bar[2]][x][3])
				AG.uiBtn[x+6]:SetTexture(icon)
			end
		end
		if AG.setdata.set[nr].bar[1]or AG.setdata.set[nr].bar[2]then AG_TTFrame:SetHidden(false)end
	end)
	c:SetHandler("OnMouseExit",function()AG_TTFrame:SetHidden(true)end)
	c:SetText(nr)
	c:SetHorizontalAlignment(TAC)
	c:SetVerticalAlignment(TAC)
	c:SetFont("ZoFontGameSmall")
	c:SetNormalFontColor(1,1,1,1)
	c:SetMouseOverFontColor(1,0.66,0.2,1)
	c:SetMouseOverTexture("AlphaGear/icon/button_over.dds")
	c:SetClickSound("Click")
	c:SetHandler("OnClicked",function()AG.LoadSet(nr)end)
	return c
end
function AG.DrawSelectButton(x,y,nr,size)
	local b=WM:CreateControl("AG_Control"..control,AG_Screen,CT_BACKDROP)
	b:SetAnchor(TOPLEFT,AG_Screen,TOPLEFT,x,y)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetCenterTexture("AlphaGear/icon/button.dds",64)
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchor(CENTER,b,CENTER,0,0)
	c:SetFont("ZoFontWinH2")
	c:SetClickSound("Click")
	c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	c:SetMouseOverTexture("AlphaGear/icon/button_over.dds")
	c:SetText(nr)
	c:SetNormalFontColor(1,1,1,0.6)
	c:SetMouseOverFontColor(1,1,1,1)
	c:SetDimensions(40,40)
	b:SetDimensions(40,40)
	if size==1 then
		c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
			if AG.SELECT then
				AG.setdata.set[AG.SET].gear=nr
				AG.SelectMode(AG.gearbtn,2,1,7)
				local pics=AG.GetSetIcon(nr)
				AG.setdata.set[AG.SET].pic[1]=pics[1]
				AG.setdata.set[AG.SET].pic[2]=pics[2]
				AG.SELECT=false
				AG.ShowSet(AG.SET)
			else
				if shift then AG.SaveGear(nr)
				elseif ctrl then AG.DeleteGear(nr)
				else AG.LoadGear(nr)end
			end
		end)
	end
	if size==2 then
		c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
			if AG.SELECT then
				AG.setdata.set[AG.SET].bar[AG.BAR]=nr
				AG.SelectMode(AG.skillbtn,2,1,15)
				AG.setbtn[AG.SET].bar[AG.BAR]:SetText(nr)
				AG.SELECT=false
				AG.ShowSet(AG.SET)
			else
				if shift then AG.SaveBar(nr)
				elseif ctrl then AG.DeleteBar(nr)
				else AG.LoadBar(nr)end
			end
		end)
	end
	if size==3 then
		c:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
		b:SetCenterTexture("AlphaGear/icon/button_big.dds",128)
		c:SetText("  "..nr)
		c:SetDimensions(121,40)
		b:SetDimensions(121,40)
		c:SetHandler("OnMouseEnter",function()
			if not AG.SELECT then
				if AG.setdata.set[nr].gear then AG.SelectMode(AG.gearbtn,1,AG.setdata.set[nr].gear,0)end
				if AG.setdata.set[nr].bar[1]then AG.SelectMode(AG.skillbtn,1,AG.setdata.set[nr].bar[1],0)end
				if AG.setdata.set[nr].bar[2]then AG.SelectMode(AG.skillbtn,1,AG.setdata.set[nr].bar[2],0)end
			end
		end)
		c:SetHandler("OnMouseExit",function()
			if not AG.SELECT then
				if AG.setdata.set[nr].gear then AG.SelectMode(AG.gearbtn,2,AG.setdata.set[nr].gear,0)end
				if AG.setdata.set[nr].bar[1]then AG.SelectMode(AG.skillbtn,2,AG.setdata.set[nr].bar[1],0)end
				if AG.setdata.set[nr].bar[2]then AG.SelectMode(AG.skillbtn,2,AG.setdata.set[nr].bar[2],0)end
			end
		end)
		c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
			AG.SET=nr
			if not AG.SELECT then
				if ctrl then
					AG.SelectMode(AG.gearbtn,2,1,7)
					AG.SelectMode(AG.skillbtn,2,1,15)
					AG.DeleteSet(nr)
					AG.ShowSet(nr)
				else AG.LoadSet(nr)end
			end
		end)
	end
	control=control+1
	return c
end
function AG.DrawItemButton(x,y,nr,slot)
	local b=WM:CreateControl("AG_Control"..control,AG_Screen,CT_BACKDROP)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterTexture("AlphaGear/icon/slot.dds",64)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetAnchor(TOPLEFT,AG_Screen,TOPLEFT,x,y)
	b:SetDimensions(40,40)
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchor(CENTER,b,CENTER,0,0)
	c:SetDimensions(38,38)
	c:SetMouseOverTexture("AlphaGear/icon/glow.dds")
	c:SetClickSound("Click")
	c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
		if not AG.SELECT then
			if shift then AG.SaveItem(nr,slot)
			elseif ctrl then AG.DeleteItem(nr,slot)
			else AG.LoadItem(nr,slot)end
		end
	end)
	control=control+1
	return c
end
function AG.DrawRepairButton()
	local b=WM:CreateControl("AG_Control"..control,ZO_ActionBar1,CT_BACKDROP)
	b:SetHidden(true)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterTexture("AlphaGear/icon/info.dds",64)
	b:SetCenterColor(1,1,1,1)
	b:SetAnchor(TOPLEFT,ActionButton8,TOPRIGHT,5,0)
	b:SetDimensions(50,50)
	control=control+1
	local t=WM:CreateControl("AG_RepairTex",b,CT_TEXTURE)
	t:SetAnchor(CENTER,b,CENTER,0,0)
	t:SetTexture("AlphaGear/icon/gear.dds")
	t:SetColor(0,1,0,1)
	t:SetDimensions(40,40)
	local c=WM:CreateControl("AG_RepairCost",b,CT_LABEL)
	c:SetAnchor(BOTTOM,b,TOP,0,-5)
	c:SetColor(1,1,1,1)
	c:SetFont("ZoFontGameSmall")
	c:SetDimensions(50,12)
	c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	local c=WM:CreateControl("AG_RepairValue",b,CT_LABEL)
	c:SetAnchor(TOP,b,BOTTOM,0,-1)
	c:SetColor(1,1,1,1)
	c:SetFont("ZoFontGameSmall")
	c:SetDimensions(50,12)
	c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	c=WM:CreateControl("AG_Repair",b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchorFill()
	c:SetClickSound("Click")
	return c
end
function AG.DrawChargeButton(name,x)
	local b=WM:CreateControl(name.."Bg",ZO_ActionBar1,CT_BACKDROP)
	b:SetHidden(true)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterTexture("AlphaGear/icon/info.dds",64)
	b:SetCenterColor(1,1,1,1)
	b:SetAnchor(TOPLEFT,AG_Repair,TOPRIGHT,5+x,0)
	b:SetDimensions(50,50)
	local t=WM:CreateControl(name.."Tex",b,CT_TEXTURE)
	t:SetAnchor(TOP,b,TOP,0,5)
	t:SetColor(1,1,1,1)
	t:SetDimensions(40,40)
	local c=WM:CreateControl(name.."Value",b,CT_LABEL)
	c:SetAnchor(TOP,b,BOTTOM,0,-1)
	c:SetColor(1,1,1,1)
	c:SetFont("ZoFontGameSmall")
	c:SetDimensions(50,12)
	c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	c=WM:CreateControl(name,b,CT_BUTTON)
	c.data={tooltipText=AG[AG.language].recharge}
	c:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
	c:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchorFill()
	c:SetClickSound("Click")
	c:SetHandler("OnClicked",function(self)
		local gem=AG.Soulgem()
		if gem then
			if name=="AG_Charge1"then ChargeItemWithSoulGem(BAG_WORN,AG.CHARGE1,BAG_BACKPACK,gem)end
			if name=="AG_Charge2"then ChargeItemWithSoulGem(BAG_WORN,AG.CHARGE1,BAG_BACKPACK,gem)end
			AG.Charge()
		end
	end)
	return c
end
function AG.DrawSkillButton(x,y,nr,slot)
	local b=WM:CreateControl("AG_Control"..control,AG_Screen,CT_BACKDROP)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetCenterTexture("AlphaGear/icon/slot.dds",64)
	b:SetAnchor(TOPLEFT,AG_Screen,TOPLEFT,x,y)
	b:SetDimensions(40,40)
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetMouseOverTexture("AlphaGear/icon/glow.dds")
	c:SetAnchor(CENTER,b,CENTER,0,0)
	c:SetDimensions(36,36)
	c:SetClickSound("Click")
	c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
		if not AG.SELECT then
			if shift then AG.SaveSkill(nr,slot)
			elseif ctrl then AG.DeleteSkill(nr,slot)
			else AG.LoadSkill(nr,slot)end
		end
	end)
	control=control+1
	return c
end
function AG.DrawIconButton(x,y,nr,bar)
	local b=WM:CreateControl("AG_Control"..control,AG_Screen,CT_BACKDROP)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetCenterTexture("AlphaGear/icon/slot.dds",64)
	b:SetAnchor(TOPLEFT,AG_Screen,TOPLEFT,x,y)
	b:SetDimensions(60,60)
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchor(CENTER,b,CENTER,0,0)
	c:SetDimensions(56,56)
	c:SetClickSound("Click")
	c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
		if not AG.SELECT then
			if shift and AG.setdata.set[nr].bar[bar]then
				if row>2 then row=row-1 else row=11 end
				self:SetNormalTexture("AlphaGear/icon/"..AG.images[row]..".dds")
				AG.setdata.set[nr].pic[bar]=row
			elseif ctrl then
				AG.setbtn[nr].pic[bar]:SetNormalTexture(nil)
				AG.setdata.set[nr].pic[bar]=nil
			elseif AG.setdata.set[nr].bar[bar]then
				if row<11 then row=row+1 else row=1 end
				self:SetNormalTexture("AlphaGear/icon/"..AG.images[row]..".dds")
				AG.setdata.set[nr].pic[bar]=row
			end
		end
	end)
	control=control+1
	return c
end
function AG.DrawSetButton(x,y,nr,mode)
	local b=WM:CreateControl("AG_Control"..control,AG_Screen,CT_BACKDROP)
	b:SetAnchor(TOPLEFT,AG_Screen,TOPLEFT,x,y)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetCenterTexture("AlphaGear/icon/button_small.dds")
	b:SetDimensions(40,19)
	if mode==2 then b:SetDimensions(39,19)end
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetFont("ZoFontWinH5")
	c:SetAnchorFill()
	c:SetClickSound("Click")
	c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
	c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	c:SetMouseOverTexture("AlphaGear/icon/button_over.dds")
	c:SetNormalFontColor(1,1,1,0.5)
	c:SetMouseOverFontColor(1,1,1,1)
	c:SetHandler("OnMouseEnter",function()
		if not AG.SELECT then
			if mode==1 and AG.setdata.set[nr].gear then AG.SelectMode(AG.gearbtn,1,AG.setdata.set[nr].gear,0)end
			if mode==2 and AG.setdata.set[nr].bar[1]then AG.SelectMode(AG.skillbtn,1,AG.setdata.set[nr].bar[1],0)end
			if mode==3 and AG.setdata.set[nr].bar[2]then AG.SelectMode(AG.skillbtn,1,AG.setdata.set[nr].bar[2],0)end
		end
	end)
	c:SetHandler("OnMouseExit",function()
		if not AG.SELECT then
			if mode==1 and AG.setdata.set[nr].gear then AG.SelectMode(AG.gearbtn,2,AG.setdata.set[nr].gear,0)end
			if mode==2 and AG.setdata.set[nr].bar[1]then AG.SelectMode(AG.skillbtn,2,AG.setdata.set[nr].bar[1],0)end
			if mode==3 and AG.setdata.set[nr].bar[2]then AG.SelectMode(AG.skillbtn,2,AG.setdata.set[nr].bar[2],0)end
		end
	end)
	c:SetHandler("OnMouseDown",function(self,button,ctrl,alt,shift)
		AG.SET=nr
		if not AG.SELECT then
			if shift then
				if mode==1 then AG.SelectMode(AG.gearbtn,1,1,7)end
				if mode==2 then AG.BAR=1;AG.SelectMode(AG.skillbtn,1,1,15)end
				if mode==3 then AG.BAR=2;AG.SelectMode(AG.skillbtn,1,1,15)end		
				AG.SELECT=true
			elseif ctrl then
				if mode==1 then AG.setdata.set[nr].gear=nil;AG.setdata.set[nr].pic[1]=nil;AG.setdata.set[nr].pic[2]=nil end
				if mode==2 then AG.setdata.set[nr].bar[1]=nil end
				if mode==3 then AG.setdata.set[nr].bar[2]=nil end	
				AG.Show()
			else
				if mode==1 then AG.LoadGear(AG.setdata.set[nr].gear)end
				if mode==2 then AG.LoadBar(AG.setdata.set[nr].bar[1])end
				if mode==3 then AG.LoadBar(AG.setdata.set[nr].bar[2])end
			end
		end
	end)
	control=control+1
	return c
end
function AG.DrawAddonButton()
	local b,c=nil,nil
	if AG_AddonButtonMover then c=AG_AddonButtonMover else c=WM:CreateControl("AG_AddonButtonMover",AG_Home,CT_BACKDROP)end
	if AG_AddonButton then b=AG_AddonButton else b=WM:CreateControl("AG_AddonButton",c,CT_BUTTON)end
	c:SetAnchor(TOPLEFT,AG_Home,TOPLEFT,AG.setdata.button[1],AG.setdata.button[2])
	c:SetDimensions(60,60)
	c:SetDrawLevel(3)
	c:SetDrawLayer(1)
	c:SetDrawTier(1)
	c:SetEdgeColor(1,0,0,0)
	c:SetEdgeTexture("",2,2,2)
	c:SetCenterColor(1,0,0,0)
	c:SetMovable(not AG.setdata.option[4])
	c:SetMouseEnabled(not AG.setdata.option[4])
	c:SetHidden(not AG.setdata.option[3])
	c:SetClampedToScreen(true)
	c:SetHandler("OnMouseUp",function(self)AG.setdata.button={self:GetLeft(),self:GetTop()}end)
	c:SetHandler("OnMouseEnter",function(self)self:SetEdgeColor(1,0,0,0.7);self:SetCenterColor(1,0,0,0.4);WM:SetMouseCursor(12)end)
	c:SetHandler("OnMouseExit",function(self)self:SetEdgeColor(1,1,1,0);self:SetCenterColor(1,0,0,0);WM:SetMouseCursor(0)end)
	b:SetState(BSTATE_NORMAL)
	b:SetAnchor(CENTER,c,CENTER,0,0)
	b:SetDimensions(40,40)
	b:SetNormalTexture("AlphaGear/icon/ag.dds")
	-- b:SetMouseOverTexture("AlphaGear/icon/ag_over.dds")
	b:SetClickSound("Click")
	b.data={tooltipText="AlphaGear"}
	b:SetHandler("OnClicked",function()AG.ShowSetup()end)
	b:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
	b:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
end
function AG.DrawButtonFrame()
	local c=nil
	if AG_ButtonFrame then c=AG_ButtonFrame else c=WM:CreateControl("AG_ButtonFrame",ZO_ActionBar1,CT_BACKDROP)end
	c:SetAnchor(TOPLEFT,ActionButton1,TOPLEFT,AG.setdata.btn[1],AG.setdata.btn[2])
	c:SetDimensions(169,89)
	c:SetEdgeColor(1,0,0,0)
	c:SetEdgeTexture("",2,2,2)
	c:SetCenterColor(1,0,0,0)
	c:SetMovable(not AG.setdata.option[4])
	c:SetMouseEnabled(not AG.setdata.option[4])
	c:SetHidden(not AG.setdata.option[2])
	c:SetClampedToScreen(true)
	c:SetHandler("OnMouseUp",function(self)AG.setdata.btn={self:GetLeft()-ZO_ActionBar1:GetLeft(),self:GetTop()-ZO_ActionBar1:GetTop()}end)
	c:SetHandler("OnMouseEnter",function(self)self:SetEdgeColor(1,0,0,0.7);self:SetCenterColor(1,0,0,0.4);WM:SetMouseCursor(12)end)
	c:SetHandler("OnMouseExit",function(self)self:SetEdgeColor(1,1,1,0);self:SetCenterColor(1,0,0,0);WM:SetMouseCursor(0)end)
end
function AG.DrawCostumeFrame()
	local c=nil
	if AG_Costumes then c=AG_Costumes else c=WM:CreateControl("AG_Costumes",AG_Home,CT_BACKDROP)end
	c:SetAnchor(TOPLEFT,AG_Home,TOPLEFT,AG.setdata.costume[1],AG.setdata.costume[2])
	c:SetDimensions(358,126)
	c:SetEdgeColor(1,0,0,0)
	c:SetEdgeTexture("",2,2,2)
	c:SetCenterColor(1,0,0,0)
	c:SetMovable(not AG.setdata.option[4])
	c:SetMouseEnabled(not AG.setdata.option[4])
	c:SetHidden(true)
	c:SetClampedToScreen(true)
	c:SetHandler("OnMouseUp",function(self)AG.setdata.costume={self:GetLeft(),self:GetTop()}end)
	c:SetHandler("OnMouseEnter",function(self)self:SetEdgeColor(1,0,0,0.7);self:SetCenterColor(1,0,0,0.4);WM:SetMouseCursor(12)end)
	c:SetHandler("OnMouseExit",function(self)self:SetEdgeColor(1,1,1,0);self:SetCenterColor(1,0,0,0);WM:SetMouseCursor(0)end)
end
function AG.DrawOptionButton(id)
	local a=WM:CreateControl("AG_Option"..id,AG_Options,CT_BUTTON)
	local b=WM:CreateControl("AG_OptionTex"..id,a,CT_BUTTON)
	b:SetAnchor(LEFT,a,RIGHT,4,0)
	b:SetDimensions(22,22)
	b:SetHandler("OnMouseEnter",function()a:SetNormalFontColor(1,0.66,0.2,1)end)
	b:SetHandler("OnMouseExit",function()a:SetNormalFontColor(1,1,1,1)end)
	a:SetAnchor(TOPRIGHT,AG_Options,TOPRIGHT,-29,5+(id-1)*28)
	a:SetText(AG[AG.language].option[id])
	a:SetFont("ZoFontGame")
	a:SetDimensions(AG_Options:GetWidth()-10,25)
	a:SetHorizontalAlignment(TAR)
	a:SetVerticalAlignment(TAC)
	a:SetNormalFontColor(1,1,1,1)
	a:SetMouseOverFontColor(1,0.66,0.2,1)
	AG.SetOption(AG.setdata.option[id],b,1)
	return a
end
function AG.DrawAddButton(arg)
	local c=WM:CreateControl("AG_Control"..control,arg.parent,CT_BUTTON)
	c:SetAnchor(arg.anchor[1],arg.anchor[2],arg.anchor[3],arg.anchor[4],arg.anchor[5])
	c:SetState(BSTATE_NORMAL)
	c:SetClickSound("Click")
	c:SetDimensions(22,22)
	c:SetHandler("OnClicked",function(self)
		AG.setdata.small=AG.ToggleOption(AG.setdata.small,self,2)
		AG.SetScreenSize()
	end)
	c.data={tooltipText=AG[AG.language].resize}
	c:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
	c:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
	control=control+1
	return c
end
function AG.DrawCostume(x,y)
	local b=WM:CreateControl("AG_Control"..control,AG_Costumes,CT_BACKDROP)
	b:SetEdgeColor(0,0,0,0)
	b:SetCenterTexture("AlphaGear/icon/slot.dds",64)
	b:SetCenterColor(0.3,0.3,0.3,1)
	b:SetAnchor(TOPLEFT,AG_Costumes,TOPLEFT,x,y)
	b:SetDimensions(32,32)
	control=control+1
	local c=WM:CreateControl("AG_Control"..control,b,CT_BUTTON)
	c:SetState(BSTATE_NORMAL)
	c:SetAnchor(CENTER,b,CENTER,0,0)
	c:SetDimensions(30,30)
	c:SetMouseOverTexture("AlphaGear/icon/glow.dds")
	c:SetClickSound("Click")
	c.data={tooltipText=nil}
	c:SetHandler("OnMouseEnter",ZO_Options_OnMouseEnter)
	c:SetHandler("OnMouseExit",ZO_Options_OnMouseExit)
	control=control+1
	return c
end
function AG.DrawWindow()
	if AG_Screen~=nil then return end
	AG.DrawScreen({name="AG_Home",size={GuiRoot:GetWidth(),GuiRoot:GetHeight()},anchor={CENTER,GuiRoot,CENTER,0,0},bg=false});AG_Home:SetHidden(false)
	AG.DrawScreen({name="AG_Screen",size={905,788},move=true,mouse=true,layer=1,level=3,tier=2,anchor={TOPLEFT,GuiRoot,TOPLEFT,AG.setdata.box[1],AG.setdata.box[2]}})
	AG_Screen:SetHandler("OnMouseUp",function()AG.setdata.box={AG_Screen:GetLeft(),AG_Screen:GetTop()}end)
	local a=AG.DrawButton({anchor={TOPRIGHT,AG_Screen,TOPRIGHT,-30,-3},size={35,35},icon="esoui/art/chatwindow/chat_options_up.dds",iconHover="esoui/art/chatwindow/chat_options_over.dds",func=function()AG_Options:SetHidden(not AG_Options:IsHidden())end})
	AG.DrawScreen({name="AG_Options",size={AG[AG.language].optionSize,#AG[AG.language].option*28+10},layer=2,level=3,tier=2,anchor={TOPRIGHT,a,BOTTOMLEFT,0,5},mouse=true})
	AG_OptionsBg:SetCenterColor(0.05,0.05,0.05,0.95)
	for z=1,#AG[AG.language].option do
		local a=AG.DrawOptionButton(z)
		local b=a:GetChild(1)
		a:SetHandler("OnClicked",function(self)
			AG.setdata.option[z]=AG.ToggleOption(AG.setdata.option[z],b,1)
			if z==12 then AG_CostumeView:SetHidden(not AG.setdata.option[12])end
			if z==10 then AG.CreateInvBg(not AG.setdata.option[10]);AG.Condition()end
			if z==8 then AG.Charge()end
			if z==7 then AG_RepairCost:SetHidden(not AG.setdata.option[7])end
			if z==6 then AG.Condition()end
			if z==4 then AG.DrawAddonButton();AG.DrawButtonFrame();AG.DrawCostumeFrame()end
			if z==3 then AG.DrawAddonButton()end
			if z==2 then AG.DrawButtonFrame()end
		end)
		b:SetHandler("OnClicked",a:GetHandler("OnClicked"))
	end
	AG.DrawButtonFrame()
	AG.DrawTTFrame()
	AG.DrawSplash()
	AG.DrawRepairButton()
	AG.DrawChargeButton("AG_Charge1",0)
	AG.DrawChargeButton("AG_Charge2",52)
	AG.DrawLabel({anchor={TOP,AG_Screen,TOP,0,3},text="|cFFAA33"..AG.name.."|r "..AG.version})
	AG.DrawOption({anchor={TOPRIGHT,AG_Screen,TOPRIGHT,-4,3},func=function()AG_Screen:SetHidden(true);AG_Options:SetHidden(true)end})
	AG.DrawButton({name="AG_Unequip",icon="esoui/art/progression/progression_indexicon_armor_up.dds",iconHover="esoui/art/progression/progression_indexicon_armor_over.dds",tooltip=AG[AG.language].unequip,size={30,30},anchor={TOPLEFT,AG_Screen,TOPLEFT,4,1},func=function()AG.GoNaked(1)end})
	AG.DrawButton({name="AG_UnequipAll",icon="esoui/art/mainmenu/menubar_character_up.dds",iconHover="esoui/art/mainmenu/menubar_character_over.dds",tooltip=AG[AG.language].unequipAll,size={30,30},anchor={TOPLEFT,AG_Screen,TOPLEFT,30,1},func=function()AG.GoNaked(3)end})
	local xpos,ypos,gearslots=51,32,{
		EQUIP_SLOT_MAIN_HAND,EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_HEAD,EQUIP_SLOT_CHEST,EQUIP_SLOT_LEGS,EQUIP_SLOT_SHOULDERS,EQUIP_SLOT_FEET,
		EQUIP_SLOT_COSTUME,EQUIP_SLOT_BACKUP_MAIN,EQUIP_SLOT_BACKUP_OFF,EQUIP_SLOT_WAIST,EQUIP_SLOT_HAND,EQUIP_SLOT_RING1,EQUIP_SLOT_RING2,EQUIP_SLOT_NECK}
	for nr=1,8 do
		AG.gearbtn[nr]={key=nil}
		AG.gearbtn[nr].key=AG.DrawSelectButton(xpos-41,ypos,nr,1)
		for x,slot in pairs(gearslots)do
			AG.gearbtn[nr][slot]=AG.DrawItemButton(xpos,ypos,nr,slot)
			xpos=xpos+41
			if x==7 then ypos=ypos+41;xpos=10 end
		end
		xpos=51;ypos=ypos+54
	end
	xpos=347;ypos=32
	for nr=1,16 do
		AG.skillbtn[nr]={key=nil}
		AG.skillbtn[nr].key=AG.DrawSelectButton(xpos,ypos,nr,2)
		for slot=1,6 do
			xpos=xpos+41
			AG.skillbtn[nr][slot]=AG.DrawSkillButton(xpos,ypos,nr,slot)
			if x==6 then ypos=ypos+41;xpos=306 end
		end
		xpos=347;
		if(nr%2)>0 then ypos=ypos+41 else ypos=ypos+54 end
	end
	xpos=643;ypos=32;x=10;y=10
	for nr=1,12 do
		AG.setbtn[nr]={key=nil,label=nil,gear=nil,bar={nil,nil},pic={nil,nil}}
		AG.setbtn[nr].key=AG.DrawSelectButton(xpos,ypos,nr,3)
		AG.setbtn[nr].label=AG.DrawLabel({anchor={RIGHT,AG.setbtn[nr].key,RIGHT,-10,0},size={78,20},halign=TEXT_ALIGN_RIGHT,text=AG.GetKey("AG_SET_"..nr),font="ZoFontGame",color={1,1,1,0.4}})
		AG.setbtn[nr].gear=AG.DrawSetButton(xpos,ypos+41,nr,1)
		AG.setbtn[nr].bar[1]=AG.DrawSetButton(xpos+41,ypos+41,nr,2)
		AG.setbtn[nr].bar[2]=AG.DrawSetButton(xpos+81,ypos+41,nr,3)
		AG.setbtn[nr].pic[1]=AG.DrawIconButton(xpos,ypos+61,nr,1)
		AG.setbtn[nr].pic[2]=AG.DrawIconButton(xpos+61,ypos+61,nr,2)
		AG.DrawUIButton(nr,x,y)
		ypos=ypos+125;x=x+26
		if nr==6 then ypos=32;xpos=774;y=35;x=10 end
	end
	AG.DrawCostumeFrame()
	for nr=1,10 do AG.costume[nr]=AG.DrawCostume(10+(nr-1)*34,82)end
	for nr=11,20 do AG.costume[nr]=AG.DrawCostume(10+(nr-11)*34,46)end
	for nr=21,30 do AG.costume[nr]=AG.DrawCostume(10+(nr-21)*34,10)end
	local c=AG.DrawAddButton({parent=AG_Screen,anchor={TOPRIGHT,AG_Screen,TOPRIGHT,-65,4},mode=1})
	AG.SetOption(AG.setdata.small,c,2)
	AG.DrawButton({name="AG_CostumeView",parent=AG_Home,anchor={BOTTOMRIGHT,AG_Costumes,BOTTOMLEFT,2,0},size={32,32},icon="esoui/art/treeicons/collection_indexicon_upgrade_up.dds",iconHover="esoui/art/treeicons/collection_indexicon_upgrade_over.dds",func=function()
		AG.ShowCostumes()
		AG_Costumes:SetHidden(not AG_Costumes:IsHidden())
	end})
	AG.DrawAddonButton()
	AG.SetScreenSize()
end

function AG.ShowSetup()
	SetGameCameraUIMode(AG_Screen:IsHidden())
	AG_Screen:SetHidden(not AG_Screen:IsHidden())
	AG_Options:SetHidden(true)
	if not AG_Screen:IsHidden()then
		AG.SELECT=false
		AG.Show()
		-- local skillTypes={SKILL_TYPE_WEAPON}
		-- for _,stId in pairs(skillTypes)do
			-- for slId=1,GetNumSkillLines(stId)do
				-- for aId=1,GetNumSkillAbilities(stId,slId)do
					-- local _,icon=GetSkillAbilityInfo(stId,slId,aId)
					-- d(stId.." "..slId.." "..aId)
					-- d("|t32:32:"..icon.."|t "..icon)
				-- end
			-- end
		-- end
	end
end
function AG.Show()
	for nr=1,8 do for x,slot in pairs(AG.gearslot)do AG.ShowItem(nr,slot)end end
	for nr=1,16 do for slot=1,6 do AG.ShowSkill(nr,slot)end end
	for nr=1,12 do AG.ShowSet(nr)end
	AG.SelectMode(AG.gearbtn,2,1,7)
	AG.SelectMode(AG.skillbtn,2,1,15)
end
function AG.ShowItem(nr,slot)
	if not nr or not slot then return end
	local function show(btn,nr,slot)
		btn.text=ItemTooltip
		InitializeTooltip(btn.text,btn,LEFT,20,0,0)
		btn.text:SetLink(AG.setdata.gear[nr][slot].link)
		ZO_ItemTooltip_ClearCondition(btn.text)
		ZO_ItemTooltip_ClearCharges(btn.text)
	end
	local function hide(btn)
		if btn.text==nil then return end
		ClearTooltip(btn.text)
		btn.text=nil
	end
	AG.gearbtn[nr][slot]:SetNormalTexture("esoui/art/characterwindow/gearslot_"..AG.icon[slot])
	AG.gearbtn[nr][slot]:GetParent():SetCenterColor(0.3,0.3,0.3,1)
	AG.gearbtn[nr][slot]:SetHandler("OnMouseEnter",nil)
	AG.gearbtn[nr][slot]:SetHandler("OnMouseExit",nil)
	if AG.setdata.gear[nr][slot]then
		if AG.setdata.gear[nr][slot].link then
			local ii={GetItemLinkInfo(AG.setdata.gear[nr][slot].link)}
			local quality=GetItemLinkQuality(AG.setdata.gear[nr][slot].link)
			AG.gearbtn[nr][slot]:SetNormalTexture(ii[1])
			AG.gearbtn[nr][slot]:SetHandler("OnMouseEnter",function(self)show(self,nr,slot)end)
			AG.gearbtn[nr][slot]:SetHandler("OnMouseExit",function(self)hide(self)end)
			AG.gearbtn[nr][slot]:GetParent():SetCenterColor(AG.color[quality][1],AG.color[quality][2],AG.color[quality][3],1)
		end
	end
end
function AG.ShowSkill(nr,slot)
	if not nr or not slot then return false end
	local function show(btn,nr,slot)
		btn.text=SkillTooltip
		InitializeTooltip(btn.text,btn,LEFT,20,0,0)
		btn.text:SetSkillAbility(AG.setdata.skill[nr][slot][1],AG.setdata.skill[nr][slot][2],AG.setdata.skill[nr][slot][3])
	end
	local function hide(btn)
		if btn.text==nil then return end
		ClearTooltip(btn.text)
		btn.text:SetHidden(true)
		btn.text=nil
	end
	if AG.setdata.skill[nr][slot][1]then
		local _,icon=GetSkillAbilityInfo(AG.setdata.skill[nr][slot][1],AG.setdata.skill[nr][slot][2],AG.setdata.skill[nr][slot][3])
		AG.skillbtn[nr][slot]:SetNormalTexture(icon)
		AG.skillbtn[nr][slot]:SetHandler("OnMouseEnter",function(self)show(self,nr,slot)end)
		AG.skillbtn[nr][slot]:SetHandler("OnMouseExit",function(self)hide(self)end)
	else
		AG.skillbtn[nr][slot]:SetNormalTexture(nil)
		AG.skillbtn[nr][slot]:SetHandler("OnMouseEnter",nil)
		AG.skillbtn[nr][slot]:SetHandler("OnMouseExit",nil)
	end
end
function AG.ShowSet(nr)
	if not nr then return end
	AG.setbtn[nr].gear:SetText(AG.setdata.set[nr].gear)
	AG.setbtn[nr].bar[1]:SetText(AG.setdata.set[nr].bar[1])
	AG.setbtn[nr].bar[2]:SetText(AG.setdata.set[nr].bar[2])
	if AG.setdata.set[nr].pic[1]then AG.setbtn[nr].pic[1]:SetNormalTexture("AlphaGear/icon/"..AG.images[AG.setdata.set[nr].pic[1]]..".dds")
	else AG.setbtn[nr].pic[1]:SetNormalTexture(nil)end
	if AG.setdata.set[nr].pic[2]then AG.setbtn[nr].pic[2]:SetNormalTexture("AlphaGear/icon/"..AG.images[AG.setdata.set[nr].pic[2]]..".dds")
	else AG.setbtn[nr].pic[2]:SetNormalTexture(nil)end
end
function AG.ShowCostumes()
	local costume,costume_id,id,x=nil,nil,1,0
	for x=2,#AG.costume do
		AG.costume[x]:SetText(x)
		AG.costume[x]:GetParent():SetHidden(true)
	end
	AG.costume[1].data={tooltipText=AG[AG.language].costume}
	AG.costume[1]:SetHandler("OnClicked",function()AG.GoNaked(2);UseCollectible(AG.LASTCID);AG.LASTCID=nil end)
	AG.costume[1]:GetParent():SetCenterTexture("AlphaGear/icon/button.dds",64)
	AG.costume[1]:SetNormalTexture("esoui/art/contacts/tabicon_ignored_up.dds")
	for x=1,GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)do
		costume_id=GetCollectibleIdFromType(COLLECTIBLE_CATEGORY_TYPE_COSTUME,x)
		costume={GetCollectibleInfo(costume_id)}
		if costume[5]then
			id=id+1
			AG.costume[id].data={tooltipText=zo_strformat("<<C:1>>",costume[1]),costumeId=costume_id}
			AG.costume[id]:SetHandler("OnClicked",function(self)AG.LASTCID=self.data.costumeId;UseCollectible(self.data.costumeId)end)
			AG.costume[id]:SetNormalTexture(costume[3])
			AG.costume[id]:GetParent():SetHidden(false)
		end
	end
	local costume=AG.GetCostumes()
	for x,slot in pairs(costume)do
		if id<#AG.costume then
			id=id+1
			local iinfo={GetItemInfo(BAG_BACKPACK,slot)}
			local iname=GetItemName(BAG_BACKPACK,slot)
			AG.costume[id].data={tooltipText=zo_strformat("<<C:1>>",iname),costumeId=slot}
			AG.costume[id]:SetHandler("OnClicked",function(self)EquipItem(BAG_BACKPACK,self.data.costumeId,EQUIP_SLOT_COSTUME)end)
			AG.costume[id]:SetNormalTexture(iinfo[1])
			AG.costume[id]:GetParent():SetHidden(false)
		end
	end
end

function AG.LoadItem(nr,slot)
	if not nr or not slot then return end
	if not AG.setdata.gear[nr][slot]then return end
	if AG.setdata.gear[nr][slot].id then
		if Id64ToString(GetItemUniqueId(BAG_WORN,slot))~=AG.setdata.gear[nr][slot].id then
			local bagSlot=AG.GetItemFromBag(AG.setdata.gear[nr][slot].id)
			if bagSlot then EquipItem(BAG_BACKPACK,bagSlot,slot)
			else d(zo_strformat(AG[AG.language].itemNotFound,AG.setdata.gear[nr][slot].link))end
		end
	else
		if AG.setdata.option[5]then if AG.setdata.set[AG.SET].gear==nr then table.insert(AG.GEARQUEUE,slot)end end
	end
end
function AG.LoadSkill(nr,slot)
    if not nr or not slot then return false end
	if AG.setdata.skill[nr][slot]==nil then return end
	local skills=AG.CheckSkill(slot)
	if skills[1]~=AG.setdata.skill[nr][slot][1]or skills[2]~=AG.setdata.skill[nr][slot][2]or skills[3]~=AG.setdata.skill[nr][slot][3]then
	SlotSkillAbilityInSlot(AG.setdata.skill[nr][slot][1],AG.setdata.skill[nr][slot][2],AG.setdata.skill[nr][slot][3],slot+2)end
end
function AG.LoadGear(nr)
	if not nr then return end
	for x,slot in pairs(AG.gearslot)do AG.LoadItem(nr,slot)end
end
function AG.LoadBar(nr)
	if not nr then return end
	for slot=1,6 do AG.LoadSkill(nr,slot)end
end
function AG.LoadSet(nr)
	if not nr then return end
	AG.ABAR=nil
	AG.SET=nr
	AG.setdata.actSet=nr
	local pair,lock=GetActiveWeaponPairInfo()
	if AG.setdata.set[nr].gear then AG.LoadGear(AG.setdata.set[nr].gear)end
	if pair==1 then
		AG.ABAR=2
		if not AG.setdata.set[nr].bar[1]then return end
		AG.LoadBar(AG.setdata.set[nr].bar[1])
	else
		AG.ABAR=1
		if not AG.setdata.set[nr].bar[2]then return end
		AG.LoadBar(AG.setdata.set[nr].bar[2])
	end
end

function AG.SaveItem(nr,slot)
	if not nr or not slot then return end
	if slot==EQUIP_SLOT_WRIST then slot=EQUIP_SLOT_HAND end
	if GetItemInstanceId(BAG_WORN,slot)then
		AG.setdata.gear[nr][slot]={id=Id64ToString(GetItemUniqueId(BAG_WORN,slot)),link=GetItemLink(BAG_WORN,slot)}
	else
		AG.setdata.gear[nr][slot]={}
	end
	AG.ShowItem(nr,slot)
end
function AG.SaveSkill(nr,slot)
	if not nr or not slot then return false end
	local skills=AG.CheckSkill(slot)
	if skills then
		AG.setdata.skill[nr][slot]=skills
		AG.ShowSkill(nr,slot)
	end
end
function AG.SaveGear(nr)
	if not nr then return end
	for x,slot in pairs(AG.gearslot)do AG.SaveItem(nr,slot)end
end
function AG.SaveBar(nr)
	if not nr then return end
	for slot=1,6 do AG.SaveSkill(nr,slot)end
end

function AG.DeleteItem(nr,slot)
	if not nr or not slot then return end
	AG.setdata.gear[nr][slot]={id=nil,link=nil}
	AG.ShowItem(nr,slot)
end
function AG.DeleteSkill(nr,slot)
	if not nr or not slot then return false end
	AG.setdata.skill[nr][slot]={}
	AG.ShowSkill(nr,slot)
end
function AG.DeleteGear(nr)
	if not nr then return end
	for x,slot in pairs(AG.gearslot)do AG.DeleteItem(nr,slot)end
end
function AG.DeleteBar(nr)
	if not nr then return end
	for slot=1,6 do AG.DeleteSkill(nr,slot)end
end
function AG.DeleteSet(nr)
	if not nr then return end
	AG.setdata.set[nr]={gear=nil,pic={nil,nil},bar={nil,nil}}
end
function AG.CheckSkill(slot)
	if not slot then return false end
	local skillTypes = {SKILL_TYPE_ARMOR,SKILL_TYPE_AVA,SKILL_TYPE_CLASS,SKILL_TYPE_GUILD,SKILL_TYPE_WEAPON,SKILL_TYPE_WORLD}
	local skillTable = {
	-- [41659] = 28858, [41663] = 28858, [41668] = 28858,
	-- [40965] = 29091, [40967] = 29091, [40970] = 29091,
	[41659] = 41754, [41663] = 41754, [41668] = 41754,
	[40965] = 40964, [40967] = 40964, [40970] = 40964,
	[41009] = 41006, [41013] = 41006, [41016] = 41006,
	[41048] = 41047, [41051] = 41047, [41054] = 41047,
	[41712] = 41711, [41717] = 41711, [41723] = 41711,
	[41770] = 41769, [41771] = 41769, [41772] = 41769,
	[42958] = 42957, [42960] = 42957, [42959] = 42957,
	[42976] = 42975, [42978] = 42975, [42980] = 42975,
	[42997] = 42996, [42999] = 42996, [43001] = 42996,
	}
	if IsSlotUsed(slot + 2) then
		local slotSkill = GetSlotBoundId(slot + 2); slotSkill = skillTable[slotSkill] or slotSkill
		for x,skillType in pairs(skillTypes) do
			for skillLine = 1, GetNumSkillLines(skillType) do
				for skillAbility = 1, GetNumSkillAbilities(skillType,skillLine) do
					if slotSkill == GetSkillAbilityId(skillType,skillLine,skillAbility,false) then return {skillType,skillLine,skillAbility} end
				end
			end
		end
	end
	return {nil,nil,nil}
end

function AG.Initialize()
	AG.setdatas={button={100,100},costume={1400,950},small=false,actSet=nil,gear={},skill={},set={},box={200,200},btn={-180,-10},option={true,true,true,false,true,true,true,true,true,true,true}}
	for x=1,12 do AG.setdatas.set[x]={gear=nil,pic={nil,nil},bar={nil,nil}}end
	for x=1,16 do AG.setdatas.skill[x]={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={}}end
	for x=1,8 do for x,slot in pairs(AG.gearslot)do AG.setdatas.gear[x]={[slot]={id=nil,link=nil}}end end
end
function IsItemInAlphaGear(uid)
	for x,gear in pairs(AG.setdata.gear)do for y,slot in pairs(gear)do if slot.id==uid then return true end end end
	return false
end
function AG.GoNaked(mode)
	if mode==1 then	AG.GEARQUEUE={
	EQUIP_SLOT_HEAD,EQUIP_SLOT_CHEST,EQUIP_SLOT_LEGS,EQUIP_SLOT_SHOULDERS,
	EQUIP_SLOT_FEET,EQUIP_SLOT_WAIST,EQUIP_SLOT_HAND}
	elseif mode==2 then AG.GEARQUEUE={EQUIP_SLOT_COSTUME}
	else AG.GEARQUEUE={
	EQUIP_SLOT_HEAD,EQUIP_SLOT_CHEST,EQUIP_SLOT_LEGS,EQUIP_SLOT_SHOULDERS,
	EQUIP_SLOT_FEET,EQUIP_SLOT_WAIST,EQUIP_SLOT_HAND,EQUIP_SLOT_COSTUME,
	EQUIP_SLOT_NECK,EQUIP_SLOT_RING1,EQUIP_SLOT_RING2,EQUIP_SLOT_MAIN_HAND,
	EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_BACKUP_MAIN,EQUIP_SLOT_BACKUP_OFF}end
end
function AG.SelectMode(btn,mode,from,count)
	for x=from,(from+count) do
		if mode==1 then btn[x].key:GetParent():SetCenterColor(1,0,0,1)
		else btn[x].key:GetParent():SetCenterColor(0.3,0.3,0.3,1)end
	end
end
function AG.Queue()
     if AG.INIT then
		if AG.GEARQUEUE[1]then
			if GetItemInstanceId(BAG_WORN,AG.GEARQUEUE[1])then
				if GetNumBagFreeSlots(BAG_BACKPACK)>0 then UnequipItem(AG.GEARQUEUE[1])
				else
					d(AG[AG.language].notEnoughSpace)
					AG.GEARQUEUE={}
				end
			end
			if not GetItemInstanceId(BAG_WORN,AG.GEARQUEUE[1])then table.remove(AG.GEARQUEUE,1)end
		end
     end
end
function AG.GetKey(keyStr)
	local layIdx,catIdx,actIdx=GetActionIndicesFromName(keyStr)
	local key=GetActionBindingInfo(layIdx,catIdx,actIdx,1)
	if key>0 then return GetKeyName(key)
	else return '' end
end
function AG.GetItemFromBag(id)
	if not id then return false end
	local bag=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	for slot,data in pairs(bag)do if id==Id64ToString(data.uniqueId)then return slot end end
	return false
end
function AG.GetCostumes()
	local bag=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	local costumes={}
	for slot,data in pairs(bag)do if data.itemType==14 then table.insert(costumes,slot)end end
	return costumes
end
function AG.GetSetIcon(nr,mode)
	if not nr then return end
	if not mode then mode=nil end
	local function GetWeaponType(nr,slot,mode)
		local wt
		if mode then wt=GetItemWeaponType(BAG_WORN,slot)
		else wt=GetItemLinkWeaponType(AG.setdata.gear[nr][slot].link)end		
		if wt==WEAPONTYPE_DAGGER or wt==WEAPONTYPE_HAMMER or wt==WEAPONTYPE_AXE or wt==WEAPONTYPE_SWORD then return 1
		elseif wt==WEAPONTYPE_TWO_HANDED_AXE or wt==WEAPONTYPE_TWO_HANDED_HAMMER or wt==WEAPONTYPE_TWO_HANDED_SWORD then return 2
		elseif wt==WEAPONTYPE_FIRE_STAFF then return 3
		elseif wt==WEAPONTYPE_FROST_STAFF then return 4
		elseif wt==WEAPONTYPE_LIGHTNING_STAFF then  return 5
		elseif wt==WEAPONTYPE_HEALING_STAFF then return 6
		elseif wt==WEAPONTYPE_BOW then return 7
		elseif wt==WEAPONTYPE_SHIELD then return 8 end
	end
	local icon={nil,nil}
	if GetWeaponType(nr,EQUIP_SLOT_MAIN_HAND,mode)==2 then icon[1]=2
	elseif GetWeaponType(nr,EQUIP_SLOT_OFF_HAND,mode)==8 then icon[1]=8
	else icon[1]=GetWeaponType(nr,EQUIP_SLOT_MAIN_HAND,mode)end
	if GetWeaponType(nr,EQUIP_SLOT_BACKUP_MAIN,mode)==2 then icon[2]=2
	elseif GetWeaponType(nr,EQUIP_SLOT_BACKUP_OFF,mode)==8 then icon[2]=8
	else icon[2]=GetWeaponType(nr,EQUIP_SLOT_BACKUP_MAIN,mode)end
	return icon
end
function AG.Soulgem()
	local result,tier=false,0
	local bag=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	for slot,data in pairs(bag)do
		if IsItemSoulGem(SOUL_GEM_TYPE_FILLED,BAG_BACKPACK,data.slotIndex)then
			local geminfo=GetSoulGemItemInfo(BAG_BACKPACK,data.slotIndex)
			if geminfo>tier then tier=geminfo;result=data.slotIndex end
		end
	end
	return result
end
function AG.Swap(eventCode,isHotbarSwap)
	local function AntiGlitch()
		local helm=tonumber(GetSetting(SETTING_TYPE_IN_WORLD,IN_WORLD_UI_SETTING_HIDE_HELM))
		SetSetting(SETTING_TYPE_IN_WORLD,IN_WORLD_UI_SETTING_HIDE_HELM,1-helm)
		SetSetting(SETTING_TYPE_IN_WORLD,IN_WORLD_UI_SETTING_HIDE_HELM,helm)
	end
    if isHotbarSwap and not IsBlockActive()then
		if AG.setdata.option[9]then
			local pair,_=GetActiveWeaponPairInfo()
			if AG.SET then
				if AG.setdata.set[AG.SET].pic[pair]then
					AG_Splash:SetTexture("AlphaGear/icon/"..AG.splash[AG.setdata.set[AG.SET].pic[pair]]..".dds")
					AG_SplashBg:SetHidden(false)
				end
			else
				local icon=AG.GetSetIcon(0,1)
				if icon[pair]then
					AG_Splash:SetTexture("AlphaGear/icon/"..AG.splash[icon[pair]]..".dds")
					AG_SplashBg:SetHidden(false)
				end
			end
			zo_callLater(function()AG_SplashBg:SetHidden(true)end,1750)
		end
		if AG.ABAR then
			if AG.setdata.set[AG.SET].bar[AG.ABAR]then
				AG.LoadBar(AG.setdata.set[AG.SET].bar[AG.ABAR])
				AG.ABAR=nil
			end
		end
		-- AntiGlitch()
    end
	AG.Charge()
end
function AG.CreateInvBg(vis)
	local inv={
	   [EQUIP_SLOT_HEAD]=ZO_CharacterEquipmentSlotsHead,
	   [EQUIP_SLOT_CHEST]=ZO_CharacterEquipmentSlotsChest,
	   [EQUIP_SLOT_SHOULDERS]=ZO_CharacterEquipmentSlotsShoulder,
	   [EQUIP_SLOT_FEET]=ZO_CharacterEquipmentSlotsFoot,
	   [EQUIP_SLOT_HAND]=ZO_CharacterEquipmentSlotsGlove,
	   [EQUIP_SLOT_LEGS]=ZO_CharacterEquipmentSlotsLeg,
	   [EQUIP_SLOT_WAIST]=ZO_CharacterEquipmentSlotsBelt,
	   [EQUIP_SLOT_RING1]=ZO_CharacterEquipmentSlotsRing1,
	   [EQUIP_SLOT_RING2]=ZO_CharacterEquipmentSlotsRing2,
	   [EQUIP_SLOT_NECK]=ZO_CharacterEquipmentSlotsNeck,
	   [EQUIP_SLOT_COSTUME]=ZO_CharacterEquipmentSlotsCostume,
	   [EQUIP_SLOT_MAIN_HAND]=ZO_CharacterEquipmentSlotsMainHand,
	   [EQUIP_SLOT_OFF_HAND]=ZO_CharacterEquipmentSlotsOffHand,
	   [EQUIP_SLOT_BACKUP_MAIN]=ZO_CharacterEquipmentSlotsBackupMain,
	   [EQUIP_SLOT_BACKUP_OFF]=ZO_CharacterEquipmentSlotsBackupOff
	}
	local tex='AlphaGear/icon/hl.dds'
	for slot,control in pairs(inv)do
		if vis==true or vis==false then
			BG[slot]:SetHidden(vis)
			BG[slot].con:SetHidden(vis)
		else
			BG[slot]=WM:CreateControl("AG_InvBg"..slot,control,CT_TEXTURE)
			BG[slot]:SetHidden(true)
			BG[slot]:SetDrawLevel(1)
			BG[slot]:SetTexture("AlphaGear/icon/hole.dds")
			BG[slot]:SetColor(1,1,1,1)
			BG[slot]:SetAnchorFill()
			local c=control:GetNamedChild("DropCallout")
			c:ClearAnchors()
			c:SetAnchor(TOP,control,TOP,0,2)
			c:SetDimensions(52,52)
			c:SetTexture(tex)
			c:SetDrawLayer(0)
			local c=control:GetNamedChild("Highlight")
			if c then
				c:SetTexture(tex)
				c:SetDimensions(52,52)
				c:SetAnchor(TOP,control,TOP,0,2)
			end
			BG[slot].con=WM:CreateControl("AG_InvCon"..slot,control,CT_LABEL)
			BG[slot].con:SetFont("ZoFontGameSmall")
			BG[slot].con:SetAnchor(BOTTOMRIGHT,BG[slot],TOPRIGHT,7,-2)
			BG[slot].con:SetDimensions(50,10)
			BG[slot].con:SetHidden(true)
			BG[slot].con:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
		end
	end
end
function AG.Condition()
	AG.Charge()
	local condition,count=0,0
	for x,slot in pairs(AG.gearslot)do
		if GetItemInstanceId(BAG_WORN,slot)then
			if AG.setdata.option[10]then
				local quality=GetItemLinkQuality(GetItemLink(BAG_WORN,slot))
				BG[slot]:SetHidden(false)
				BG[slot]:SetColor(AG.color[quality][1],AG.color[quality][2],AG.color[quality][3],1)
				BG[slot]:GetParent():SetMouseOverTexture(not ZO_Character_IsReadOnly()and 'AlphaGear/icon/mo.dds' or nil)
				BG[slot]:GetParent():SetPressedMouseOverTexture(not ZO_Character_IsReadOnly()and 'AlphaGear/icon/mo.dds' or nil)
				if DoesItemHaveDurability(BAG_WORN,slot)then
					local con=GetItemCondition(BAG_WORN,slot)
					condition=condition+con
					count=count+1
					local r,g,b=AG.Color(con)
					BG[slot].con:SetText(con.."%")
					BG[slot].con:SetColor(r,g,b,0.9)
					BG[slot].con:SetHidden(false)
				else BG[slot].con:SetHidden(true)end
			end
		else
			BG[slot]:SetHidden(true)
			BG[slot].con:SetHidden(true)
		end
	end
	condition=math.floor(condition/count)
	if AG.setdata.option[6]then
		local r,g,b=AG.Color(condition)
		AG_Repair:GetParent():SetHidden(false)
		AG_RepairTex:SetColor(r,g,b,1)
		if AG.setdata.option[7]then AG_RepairCost:SetText(GetRepairAllCost().." |t12:12:esoui/art/currency/currency_gold.dds|t");AG_RepairCost:SetHidden(false)
		else AG_RepairCost:SetHidden(true)end
		AG_RepairValue:SetText(condition.."%")
		AG_RepairValue:SetColor(r,g,b,1)
	else AG_Repair:GetParent():SetHidden(true)end
end
function AG.Charge()
	if not AG.setdata.option[8]then
		AG_Charge1Bg:SetHidden(true)
		AG_Charge2Bg:SetHidden(true)
		return
	end
	local pair,lock=GetActiveWeaponPairInfo()
	local weapon1,weapon2,charge1,charge2=nil,nil,nil,nil
	if pair==1 then
		if IsItemChargeable(BAG_WORN,EQUIP_SLOT_MAIN_HAND)then
			charge1={GetChargeInfoForItem(BAG_WORN,EQUIP_SLOT_MAIN_HAND)}
			weapon1={GetItemInfo(BAG_WORN,EQUIP_SLOT_MAIN_HAND)}
			AG.CHARGE1=EQUIP_SLOT_MAIN_HAND
		end
		if IsItemChargeable(BAG_WORN,EQUIP_SLOT_OFF_HAND)then
			charge2={GetChargeInfoForItem(BAG_WORN,EQUIP_SLOT_OFF_HAND)}
			weapon2={GetItemInfo(BAG_WORN,EQUIP_SLOT_OFF_HAND)}
			AG.CHARGE2=EQUIP_SLOT_OFF_HAND
		end
	else
		if IsItemChargeable(BAG_WORN,EQUIP_SLOT_BACKUP_MAIN)then
			charge1={GetChargeInfoForItem(BAG_WORN,EQUIP_SLOT_BACKUP_MAIN)}
			weapon1={GetItemInfo(BAG_WORN,EQUIP_SLOT_BACKUP_MAIN)}
			AG.CHARGE1=EQUIP_SLOT_BACKUP_MAIN
		end
		if IsItemChargeable(BAG_WORN,EQUIP_SLOT_BACKUP_OFF)then
			charge2={GetChargeInfoForItem(BAG_WORN,EQUIP_SLOT_BACKUP_OFF)}
			weapon2={GetItemInfo(BAG_WORN,EQUIP_SLOT_BACKUP_OFF)}
			AG.CHARGE2=EQUIP_SLOT_BACKUP_OFF
		end
	end
	ZO_ActionBar1KeybindBG:SetWidth(680)
	ZO_ActionBar1KeybindBG:SetAnchor(LEFT,ZO_ActionBar1,LEFT,-60,0)
	if charge1 then
		local charge=math.floor(charge1[1]/charge1[2]*100)
		local r,g,b=AG.Color(charge)
		AG_Charge1Tex:SetTexture(weapon1[1])
		AG_Charge1Value:SetText(charge.."%")
		AG_Charge1Value:SetColor(r,g,b,1)
		AG_Charge1Bg:SetHidden(false)
		ZO_ActionBar1KeybindBG:SetWidth(710)
	else AG_Charge1Bg:SetHidden(true)end
	if charge2 then
		local charge=math.floor(charge2[1]/charge2[2]*100)
		local r,g,b=AG.Color(charge)
		AG_Charge2Tex:SetTexture(weapon2[1])
		AG_Charge2Value:SetText(charge.."%")
		AG_Charge2Value:SetColor(r,g,b,1)
		AG_Charge2Bg:SetHidden(false)
		ZO_ActionBar1KeybindBG:SetWidth(760)
	else AG_Charge2Bg:SetHidden(true)end
end
function AG.Color(val)
	local r,g,b=0,0,0
	if val>=50 then r=100-((val-50)*2);g=100 else r=100;g=val*2 end
	return r/100,g/100,b
end
function AG.ToggleOption(condition,btn,val)
	AG.SetOption(not condition,btn,val)
	return not condition
end
function AG.SetScreenSize()
	if AG.setdata.small then
		AG_Screen:SetDimensions(775,788)
		AG_ScreenBg:SetDimensions(785,798)
	else
		AG_Screen:SetDimensions(905,788)
		AG_ScreenBg:SetDimensions(915,798)
	end
	for x=7,12 do
		AG.setbtn[x].key:GetParent():SetHidden(AG.setdata.small)
		AG.setbtn[x].label:SetHidden(AG.setdata.small)
		AG.setbtn[x].gear:GetParent():SetHidden(AG.setdata.small)
		AG.setbtn[x].bar[1]:GetParent():SetHidden(AG.setdata.small)
		AG.setbtn[x].bar[2]:GetParent():SetHidden(AG.setdata.small)
		AG.setbtn[x].pic[1]:GetParent():SetHidden(AG.setdata.small)
		AG.setbtn[x].pic[2]:GetParent():SetHidden(AG.setdata.small)
	end
end
function AG.SetOption(condition,btn,val)
	local tex={[0]='esoui/art/buttons/<<1>>_<<2>>.dds',[1]={'accept','decline'},[2]={'pointsplus','pointsminus'}}
	if condition then
		btn:SetNormalTexture(zo_strformat(tex[0],tex[val][1],'up'))
		btn:SetMouseOverTexture(zo_strformat(tex[0],tex[val][1],'over'))
	else
		btn:SetNormalTexture(zo_strformat(tex[0],tex[val][2],'up'))
		btn:SetMouseOverTexture(zo_strformat(tex[0],tex[val][2],'over'))
	end
end
function AG.SetMark(row,data)
	local function GetMark(control)
		local name=control:GetName()
		if not IM[name]then IM[name]=WM:CreateControl(name.."_AG_SetMark",control,CT_TEXTURE)end
		return IM[name]
	end
    local slot=row.dataEntry.data
	local mark=GetMark(row)
	local uid=Id64ToString(GetItemUniqueId(slot.bagId,slot.slotIndex))
	mark:SetHidden(true)
	mark:SetTexture("esoui/art/itemtooltip/item_chargemeter_bar_genericfill.dds")
	mark:SetColor(1,0.3,0,0.7)
	mark:SetDrawLayer(3)
	mark:ClearAnchors()
	if row:GetWidth()-row:GetHeight()<5 then
		mark:SetDimensions(row:GetWidth()-8,4)
		mark:SetAnchor(BOTTOMLEFT,row,BOTTOMLEFT,4,-1)
	else				
		mark:SetDimensions(4,row:GetHeight()-8)
		mark:SetAnchor(TOPLEFT,row,TOPLEFT,15,4)
	end
	if AG.setdata.option[11]then
		for x,gear in pairs(AG.setdata.gear)do
			for y,gslot in pairs(gear)do
				if gslot.id==uid then
					mark:SetHidden(false)
					return
				end
			end
		end
	end
end
function AG.UpdateInventory()
	local inv={
		ZO_PlayerInventoryBackpack,ZO_PlayerBankBackpack,
		ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack,
		ZO_SmithingTopLevelImprovementPanelInventoryBackpack,
	}
	for x=1,#inv do
		local puffer=inv[x].dataTypes[1].setupCallback
		inv[x].dataTypes[1].setupCallback=function(control,slot)
			puffer(control,slot)
			AG.SetMark(control)
		end
	end
end
function AG.TooltipShow(control,id)
	if AG.setdata.option[11]and id then
		local sets=''
		for x,gear in pairs(AG.setdata.gear)do
			for y,slot in pairs(gear)do
				if slot.id==id then sets=sets..x.." "end
			end
		end
		if sets~=""then control:AddLine("\n|cFF6622"..AG[AG.language].gearhint..sets.."|r","ZoFontGameSmall")end
	end
end
function AG.TooltipHandle()
	local tt=ItemTooltip.SetBagItem
	ItemTooltip.SetBagItem=function(control,bagId,slotIndex,...)
		tt(control,bagId,slotIndex,...)
		AG.TooltipShow(control,Id64ToString(GetItemUniqueId(bagId,slotIndex)))
	end
end
function AG.CloseAll()
	AG_Screen:SetHidden(true)
	AG_Options:SetHidden(true)
	AG_Costumes:SetHidden(true)
	AG_CostumeView:SetHidden(true)
	AG_AddonButtonMover:SetHidden(true)
end

function AG.LoadAddon(eventCode,addOnName)
	if addOnName~="AlphaGear" then return end
	if not(AG.language=="en" or AG.language=="fr" or AG.language=="de")then AG.language="en" end
	AG.setdata=ZO_SavedVars:New("AG_Character",1,nil,AG.setdatas)
	for i=1,12 do ZO_CreateStringId("SI_BINDING_NAME_AG_SET_"..i,"LoadSet "..i) end
	ZO_CreateStringId("SI_BINDING_NAME_AG_NAKED","Unequip all Armor")
	ZO_CreateStringId("SI_BINDING_NAME_AG_MAIN","Toggle AlphaGear Screen")
	EM:UnregisterForEvent("ALPHA_GEAR",EVENT_ADD_ON_LOADED)
	AG.DrawWindow()
	AG.UpdateInventory()
	AG.CreateInvBg(nil)
	AG.INIT=true
	EM:RegisterForEvent("ALPHA_GEAR",EVENT_INVENTORY_SINGLE_SLOT_UPDATE,AG.Condition)
	EM:RegisterForEvent("ALPHA_GEAR",EVENT_ACTION_SLOTS_FULL_UPDATE,AG.Swap)
	EM:RegisterForEvent("ALPHA_GEAR",EVENT_GAME_CAMERA_UI_MODE_CHANGED,function()
		if not IsGameCameraUIModeActive()then if AG.setdata.option[1]then AG.CloseAll()end
		else
			AG_AddonButtonMover:SetHidden(not AG.setdata.option[3])
			AG_CostumeView:SetHidden(not AG.setdata.option[12])
		end
	end)
	CHAMPION_PERKS_SCENE:RegisterCallback("StateChange",function(oldState,newState)
		if newState==SCENE_SHOWING then AG.CloseAll()else AG_AddonButtonMover:SetHidden(not AG.setdata.option[3]);AG_CostumeView:SetHidden(not AG.setdata.option[12])end
	end)
	if AG.setdata.option[5]then AG.Condition()end
	AG_ButtonFrame:SetMovable(not AG.setdata.option[4])
	AG_ButtonFrame:SetHidden(not AG.setdata.option[2])
end
EM:RegisterForEvent("ALPHA_GEAR",EVENT_ADD_ON_LOADED,function(eventCode,addOnName)
	if addOnName=="AlphaGear" then
		AG.Initialize()
		AG.TooltipHandle()
		AG.LoadAddon(eventCode,addOnName)
	end
end)
