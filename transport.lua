AlphaLoot = {
	name = 'AlphaLoot',
	version = '4.00',
	author = 'AlphaLemming',
	init = false
}
local EM = EVENT_MANAGER
local idle, al_main, al_show = 0

function AlphaLoot:SHOW()
	self = {}
	local loot, reset
	local slide = 4000
	local top = -GuiRoot:GetHeight()/2-100
	
	local function ClearControl(control)
		control:SetHidden(true)
		control:ClearAnchors()
	end
	
	local function DrawLoot(control)
		local container = AlphaLootFrame:CreateControl('AlphaLoot'..control:GetNextControlId(),CT_CONTROL)
		local icon = container:CreateControl('$(parent)Icon',CT_TEXTURE)
		local bag = container:CreateControl('$(parent)Bag',CT_TEXTURE)
		local bank = container:CreateControl('$(parent)Bank',CT_TEXTURE)
		local count = container:CreateControl('$(parent)Count',CT_LABEL)
		local bagcount = container:CreateControl('$(parent)BagCount',CT_LABEL)
		local bankcount = container:CreateControl('$(parent)BankCount',CT_LABEL)
		local name = container:CreateControl('$(parent)Name',CT_LABEL)
		container:SetAnchor(128,AlphaLootFrame,128,0,0)
		icon:SetAnchor(3,container,3,0,0)
		icon:SetDimensions(40,40)
		count:SetAnchor(9,icon,9,5,5)
		count:SetFont('ALFontSmall')
		count:SetColor(1,1,1,1)
		name:SetAnchor(2,icon,8,10,0)
		name:SetFont('ALFontBig')
		bag:SetAnchor(2,name,8,10,0)
		bag:SetTexture('esoui/art/icons/servicetooltipicons/gamepad/gp_servicetooltipicon_bagvendor.dds')
		bag:SetDimensions(24,24)
		bag:SetHidden(true)
		bagcount:SetAnchor(6,bag,6,5,5)
		bagcount:SetFont('ALFontSmall')
		bagcount:SetColor(1,0.9,0.7,1)
		bank:SetAnchor(2,bagcount,8,10,0)
		bank:SetTexture('esoui/art/icons/servicetooltipicons/gamepad/gp_servicetooltipicon_banker.dds')
		bank:SetDimensions(24,24)
		bank:SetHidden(true)
		bankcount:SetAnchor(6,bank,6,5,5)
		bankcount:SetFont('ALFontSmall')
		bankcount:SetColor(1,0.9,0.7,1)
		return container
	end
	
	local function DrawGold(control)
		local container = AlphaLootFrame:CreateControl('AlphaLoot'..control:GetNextControlId(),CT_CONTROL)
		local icon = container:CreateControl('$(parent)Icon',CT_TEXTURE)
		local count = container:CreateControl('$(parent)Count',CT_LABEL)
		container:SetAnchor(128,AlphaLootFrame,128,0,0)
		icon:SetAnchor(3,container,3,0,0)
		icon:SetDimensions(40,40)
		icon:SetTexture('esoui/art/icons/item_generic_coinbag.dds')
		count:SetAnchor(6,icon,6,5,5)
		count:SetFont('ALFontSmall')
		count:SetColor(1,1,0,1)
		return container
	end

	local function DrawXP(control)
		local container = AlphaLootFrame:CreateControl('AlphaLoot'..control:GetNextControlId(),CT_CONTROL)
		local name = container:CreateControl('$(parent)Name',CT_LABEL)
		container:SetAnchor(128,AlphaLootFrame,128,0,0)
		name:SetAnchor(3,container,3,0,0)
		name:SetFont('ALFontBig')
		name:SetColor(0,1,0,1)
		return container
	end

	local function Slide(c,x1,y1,x2,y2,duration)
		local a = ANIMATION_MANAGER:CreateTimeline()
		local s = a:InsertAnimation(ANIMATION_TRANSLATE,c)
		local fi = a:InsertAnimation(ANIMATION_ALPHA,c)
		local fo = a:InsertAnimation(ANIMATION_ALPHA,c,duration-500)
		fi:SetAlphaValues(0,1)
		fi:SetDuration(100)
		s:SetStartOffsetX(x1)
		s:SetStartOffsetY(y1)
		s:SetEndOffsetX(x2)
		s:SetEndOffsetY(y2)
		s:SetDuration(duration)
		fo:SetAlphaValues(1,0)
		fo:SetDuration(500)
		a:PlayFromStart()
	end
	
	function self:ShowLoot(link,count,icon,bag,bank)
		loot,reset = ZO_ObjectPool:New(DrawLoot,ClearControl)
		loot:GetNamedChild('Icon'):SetTexture(icon)
		loot:GetNamedChild('Name'):SetText(link)
		if count > 1 then loot:GetNamedChild('Count'):SetText(count) end
		if bag > 1 then
			loot:GetNamedChild('Bag'):SetHidden(false)
			loot:GetNamedChild('BagCount'):SetText(bag)
		end
		if bank > 1 then
			loot:GetNamedChild('Bank'):SetHidden(false)
			loot:GetNamedChild('BankCount'):SetText(bank)
		end
		Slide(loot,0,0,0,top,slide)
		zo_callLater(function() loot:ReleaseObject(reset) end, slide+10)
	end
	
	function self:ShowGold(count)
		loot,reset = ZO_ObjectPool:New(DrawGold,ClearControl)
		loot:GetNamedChild('Count'):SetText(count)
		Slide(loot,200,0,200,top,slide)
		zo_callLater(function() loot:ReleaseObject(reset) end, slide+10)
	end
	
	function self:ShowXP(count)
		loot,reset = ZO_ObjectPool:New(DrawXP,ClearControl)
		loot:GetNamedChild('Name'):SetText(count)
		Slide(loot,-200,0,-200,top,slide)
		zo_callLater(function() loot:ReleaseObject(reset) end, slide+10)
	end

	function self:ShowGXP(name,count)
		loot,reset = ZO_ObjectPool:New(DrawXP,ClearControl)
		loot:GetNamedChild('Name'):SetText(name..': +'..count)
		Slide(loot,-200,0,-200,top,slide)
		zo_callLater(function() loot:ReleaseObject(reset) end, slide+10)
	end

	return self
end

function AlphaLoot:MAIN()
	self = {}
	local bagCache = {}
	local xpCache = {}
	local queue = {}

	local function HandleLoot(_,bag,slot,new)
		if bag ~= BAG_BACKPACK then return end
		if new then
			local icon,_,price,_,_,et,is,q = GetItemInfo(BAG_BACKPACK,slot)
			local link = GetItemLink(BAG_BACKPACK,slot)
			local bag, bank = GetItemLinkStacks(link)
			queue[link] = {GetTimeStamp(),bag - bagCache[slot],icon,bag,bank}
			zo_callLater(function() bagCache[slot] = bag end,200)
		end
	end
	
	local function HandleGold(_,new,old)
		local gold = new - old
		if gold > 0 then queue['gold'] = {GetGameTimeMilliseconds(),gold} end
	end

	local function HandleXP(_,_,_,old,new)
		local xp = new - old
		if xp > 0 then queue['xp'] = {GetGameTimeMilliseconds(),xp} end
		for x = 1, GetNumSkillLines(SKILL_TYPE_GUILD) do
			local _,_,xp = GetSkillLineXPInfo(SKILL_TYPE_GUILD,x)
			local name = GetSkillLineInfo(SKILL_TYPE_GUILD,x)
			local nxp = xp - xpCache[name]
			if nxp > 0 then
				queue['gxp'] = {GetGameTimeMilliseconds(),name,nxp}
				zo_callLater(function() xpCache[name] = nxp end,200)
			end
		end
	end
	
	function self:GetQueue() return queue end
	function self:SetQueue(nr) queue[nr] = nil end
	
	for slot = 0, GetBagSize(BAG_BACKPACK) - 1 do bagCache[slot] = GetItemTotalCount(BAG_BACKPACK,slot) end
	for x = 1, GetNumSkillLines(SKILL_TYPE_GUILD) do
		local _,_,xp = GetSkillLineXPInfo(SKILL_TYPE_GUILD,x)
		xpCache[GetSkillLineInfo(SKILL_TYPE_GUILD,x)] = xp
	end
	
	EM:RegisterForEvent('AlphaLoot_HandleLoot', EVENT_SINGLE_SLOT_UPDATE, HandleLoot)
	EM:RegisterForEvent('AlphaLoot_HandleGold', EVENT_MONEY_CHANGE, HandleGold)
	EM:RegisterForEvent('AlphaLoot_HandleXP', EVENT_EXPERIENCE_GAIN, HandleXP)
	
	return self
end

function AlphaLoot:Queue()
	if AlphaLoot.init then
		for link,loot in pairs(al_main:GetQueue()) do
			local gtms = GetGameTimeMilliseconds()
			if gtms >= loot[1] + 150 and gtms >= idle then
				if link == 'xp' then al_show:ShowXP(loot[2])
				elseif link == 'gxp' then al_show:ShowGXP(loot[2],loot[3])
				elseif link == 'gold' then al_show:ShowGold(loot[2])
				else al_show:ShowLoot(link,loot[2],loot[3],loot[4],loot[5]) end
				al_main:SetQueue(link)
				idle = gtms + 25
			end
		end
	end
end

EM:RegisterForEvent('AlphaLoot_AddonLoad', EVENT_ADD_ON_LOADED, function(_,name)
    if name ~= 'AlphaLoot' then return end
	al_main = AlphaLoot:MAIN()
	al_show = AlphaLoot:SHOW()
	AlphaLoot.init = true
	EM:UnregisterForEvent('AlphaLoot_AddonLoad', EVENT_ADD_ON_LOADED)
end)
