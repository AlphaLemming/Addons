EM:RegisterForEvent('CraftStore_HideOnMove',EVENT_NEW_MOVEMENT_IN_UI_MODE, function()
	if CraftStore.account.option[11] then
		SM:HideTopLevel(CS4_Panel)
		SM:HideTopLevel(CS4_Style)
		SM:HideTopLevel(CS4_Sets)
		SM:HideTopLevel(CS4_Cook)
		SM:HideTopLevel(CS4_Rune)
		SM:HideTopLevel(CS4_Flask)
	end
end)
EM:UnregisterForEvent('CraftStore_HideOnMove',EVENT_NEW_MOVEMENT_IN_UI_MODE)

function CraftStore:PLAYER()
	self = {}
	local bagCache = {}
	local EM, WM = EVENT_MANAGER, WINDOW_MANAGER
	local SELF, CHAR = GetUnitName('player'), GetUnitName('player')
	local TRAIT = CraftStore:TRAIT()
	local LANG = CraftStore:LANGUAGE()
	local TOOLS = CraftStore:TOOLS()
	local _,_,maxtrait = GetSmithingResearchLineInfo(1,1)
	
	function self:SetPlayer(player) CHAR = player end
	
	function self:SetPlayerStyles(val) CraftStore.account.player[CHAR].styles = val or false end
	
	function self:SetPlayerRecipes(val) CraftStore.account.player[CHAR].recipes = val or false end
	
	function self:SetPlayerAnnounced(player,val) CraftStore.account.player[player].anncounced = val or false end
	
	function self:GetIsSelf(player) return player == SELF end
	
	function self:GetPlayer() return CHAR end
	
	function self:GetPlayerValues() return CraftStore.account.player[CHAR] end
	
	function self:GetPlayerStyles() return CraftStore.account.player[CHAR].styles or false end
	
	function self:GetPlayerRecipes() return CraftStore.account.player[CHAR].recipes or false end
	
	function self:GetPlayerAnnounced(player) return CraftStore.account.player[player].anncounced or false end
	
	local function SetPlayerLevel() CraftStore.account.player[SELF].level = GetUnitEffectiveLevel('player') end
	
	local function SetPlayerMount()
		local ride = {GetRidingStats()}
		local ridetime = GetTimeUntilCanBeTrained()/1000
		if ridetime > 0 then ridetime = ridetime + GetTimeStamp() else ridetime = 0 end
		CraftStore.account.player[SELF].speed = ride[5]..' / '..ride[6]
		CraftStore.account.player[SELF].stamina = ride[3]..' / '..ride[4]
		CraftStore.account.player[SELF].capacity = ride[1]..' / '..ride[2]
		CraftStore.account.player[SELF].training = ridetime
	end
	
	local function SetPlayerSkill()
		CraftStore.account.player[SELF].crafting = {
			[CRAFTING_TYPE_BLACKSMITHING] = TOOLS:GetBonus(NON_COMBAT_BONUS_BLACKSMITHING_LEVEL, CRAFTING_TYPE_BLACKSMITHING),
			[CRAFTING_TYPE_CLOTHIER] = TOOLS:GetBonus(NON_COMBAT_BONUS_CLOTHIER_LEVEL, CRAFTING_TYPE_CLOTHIER),
			[CRAFTING_TYPE_ENCHANTING] = TOOLS:GetBonus(NON_COMBAT_BONUS_ENCHANTING_LEVEL, CRAFTING_TYPE_ENCHANTING),
			[CRAFTING_TYPE_ALCHEMY] = TOOLS:GetBonus(NON_COMBAT_BONUS_ALCHEMY_LEVEL, CRAFTING_TYPE_ALCHEMY),
			[CRAFTING_TYPE_PROVISIONING] = TOOLS:GetBonus(NON_COMBAT_BONUS_PROVISIONING_LEVEL, CRAFTING_TYPE_PROVISIONING),
			[CRAFTING_TYPE_WOODWORKING] = TOOLS:GetBonus(NON_COMBAT_BONUS_WOODWORKING_LEVEL, CRAFTING_TYPE_WOODWORKING)
		}			
	end

	-- function self:GetTraitNeedy(link)
		-- local needy = {}
		-- local craft, line, trait = TRAIT:FindTrait(link)
		-- if craft and line and trait then
			-- for _,char in pairs(self:GetCharacters()) do
				-- if self:GetTrait(craft,line,trait) == false then table.insert(needy,char) end
			-- end
		-- end
		-- if #needy == 0 then return false else return needy end
	-- end

	local function SetTrait(craft,line,trait)
		local _,_,known = GetSmithingResearchLineTraitInfo(craft,line,trait)
		local _,dur = GetSmithingResearchLineTraitTimes(craft,line,trait)
		if not known and dur and dur > 0 then known = dur end
		CraftStore.account.player[SELF].research[craft][line][trait] = known or false
	end

	local function GetTrait(craft,line,trait,player)
		if player and player ~= SELF then
			return CraftStore.account.player[player].research[craft][line][trait] or false
		else
			local t,_ = CraftStore.account.player[SELF].research[craft][line][trait]
			if t ~= false and t ~= true	and t > 0 then _,t = GetSmithingResearchLineTraitTimes(craft,line,trait) end
			return t
		end
	end	

	local function GetTraitSummary(craft,line,trait)
		local tip = {}
		for _,char in pairs(TOOLS:GetCharacters()) do
			local val = GetTrait(craft,line,trait,char)
			if val == true then table.insert(tip,'|t14:14:CraftStore4/tick.dds|t |c44FF44'..char..'|r')
			elseif val == false then table.insert(tip,'|t14:14:CraftStore4/cross.dds|t |cFF4444'..char..'|r')
			elseif val and val > 0 then table.insert(tip,'|t14:14:CraftStore4/time.dds|t |c42A6F7'..char..' ('..TOOLS:GetTime(val)..')|r') end
		end
		return table.concat(tip,'\n')
	end

	local function GetLink(craft,line,trait)
		local pos = 0
		if trait == 9 then pos = CraftStore.trait9[craft][line] else pos = (trait-1) * 35 end
		return '|H1:item:'..(CraftStore.traititems[craft][line] + pos)..':0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:10000:0|h|h'
	end

	local function GetStored(craft,line,trait) return CraftStore.account.stored[craft..'&'..line..'&'..trait] or false end		
	
	local function SetIcon(craft,line,trait)
		if not craft or not line or not trait then return end
		local traitname = GetString('SI_ITEMTRAITTYPE',GetSmithingResearchLineTraitInfo(craft,line,trait)) or ''
		local known, store = GetTrait(craft,line,trait), GetStored(craft,line,trait)
		local tip, chatlink = GetTraitSummary(craft,line,trait) or '', GetLink(craft,line,trait)
		local c = WM:GetControlByName('CS4_Craft'..craft..'Line'..line..'Trait'..trait)
		c.cs_data = { info = '|cFFFFFF'..traitname..'|r\n'..tip, trait = chatlink, anchor = {c,3,9,2,0} }
		if known == false then
			if store then
				tip = '\n|t14:14:CraftStore4/plus.dds|t |cFFDD66'..store.owner..'|r\n'..tip
				c:SetNormalTexture('CraftStore4/plus_bg.dds')
				c.cs_data = { link = store.link, line = {tip}, trait = chatlink, anchor = {CS4_Panel,3,9,2,0} }
			else c:SetNormalTexture('CraftStore4/cross_bg.dds') end
		elseif known == true then c:SetNormalTexture('CraftStore4/tick_bg.dds')
		else c:SetNormalTexture('CraftStore4/time_bg.dds') end
	end

	local function GetTraitCount(craft,line)
		local count = 0
		for _,trait in pairs(CraftStore.account.player[self:GetPlayer()].research[craft][line]) do
			if trait == true then count = count + 1 end
		end
		return count
	end

	local function SetCount(craft,line)
		if not craft or not line then return end
		WM:GetControlByName('CS4_Craft'..craft..'Line'..line..'Count'):SetText(GetTraitCount(craft,line))
	end
	
	local function InvMonitor(_,bag,slot)
        if bag == 0 or bag > 2 then return end
		local link, uid, id, gone = nil, nil, nil, false
		link = GetItemLink(bag,slot)
		if not link or link == '' then
			link = bagCache[bag][slot].link
			gone = true
		end
		uid = Id64ToString(GetItemUniqueId(bag,slot))
		id = TOOLS:SplitLink(link,3) or bagCache[bag][slot].id
		-- d('InvMonitor: '..(bag or 'NoBag')..' - '..(slot or 'NoSlot'))
		-- d('InvMonitor: '..(link or 'NoLink'))
		-- d(gone)
		local a1, a2 = GetItemLinkStacks(link)
		if not CraftStore.account.stock[id] then CraftStore.account.stock[id] = {} end
		if a1 > 0 then CraftStore.account.stock[id][SELF] = a1 else CraftStore.account.stock[id][SELF] = nil end
		if a2 > 0 then CraftStore.account.stock[id]['aa'] = a2 else CraftStore.account.stock[id]['aa'] = nil end
		if next(CraftStore.account.stock[id]) == nil then CraftStore.account.stock[id] = nil end
		local craft,line,trait = TRAIT:FindTrait(link)
		local isSet = GetItemLinkSetInfo(link)
		if craft and line and trait and uid and not isSet then
			local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false }
			local owner = SELF
			if bag == BAG_BANK then owner = LANG:Get('bank') end
			if gone then
				if bagCache[bag][slot].uid == store.id then CraftStore.account.stored[craft..'&'..line..'&'..trait] = nil end
			elseif TOOLS:CompareItem(link, store.link) or (store.owner and owner ~= store.owner) then
				CraftStore.account.stored[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid }
			end
			SetIcon(craft,line,trait)
		end
		if not gone then bagCache[bag][slot] = { link = link, uid = uid, id = id } end
	end
	
	local function StoreCheck(bag,slot)
        if bag == 0 or bag > 2 then return end
		local link, uid, id = bagCache[bag][slot].link, bagCache[bag][slot].uid, bagCache[bag][slot].id
		local a1, a2 = GetItemLinkStacks(link)
		if not CraftStore.account.stock[id] then CraftStore.account.stock[id] = {} end
		if a1 > 0 then CraftStore.account.stock[id][SELF] = a1 else CraftStore.account.stock[id][SELF] = nil end
		if a2 > 0 then CraftStore.account.stock[id]['aa'] = a2 else CraftStore.account.stock[id]['aa'] = nil end
		if next(CraftStore.account.stock[id]) == nil then CraftStore.account.stock[id] = nil end
		local craft,line,trait = TRAIT:FindTrait(link)
		local isSet = GetItemLinkSetInfo(link)
		if craft and line and trait and uid and not isSet then
			local store = CraftStore.account.stored[craft..'&'..line..'&'..trait]
			if store and bagCache[bag][slot].uid == store.id then CraftStore.account.stored[craft..'&'..line..'&'..trait] = nil end
			SetIcon(craft,line,trait)
		end
	end

	local function SetInitalActive(craft,line)
		local c, a = WM:GetControlByName('CS4_Craft'..craft..'Line'..line)
		a = CraftStore.account.player[CHAR].research[craft][line].active
		if c then		
			for x = 1, c:GetNumChildren() do c:GetChild(x):SetHidden(not a) end
		end
		WM:GetControlByName('CS4_Craft'..craft..'Line'..line..'DisabledTexture'):SetHidden(a)
	end	

	local RESEARCH = {}
	local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}

	local function SetPlayerResearch(craft)
		local p, current, color, maxsim, level, rank, c, t, data = WM:GetControlByName('CS4_Research'..craft), 0, '|cFFFFFF'
		local pip = '|r|c999999  '..GetString(SI_BULLET)..'|r '
		for x = 1,3 do
			c = p:GetNamedChild('Line'..x)
			t = p:GetNamedChild('Time'..x)
			data = next(RESEARCH[CHAR][craft])
			if data then
				t:SetText(TOOLS:GetTime(data[3])..'|t8:5:x.dds|t')
				c:SetText(data[1])
				c.cs_data = { info = data[2], anchor = {3,c,9,0,2} }
				current = current + 1
			else
				t:SetText('')
				c:SetText('')
				c.cs_data = nil
			end
		end
		level, rank, maxsim = unpack(CraftStore.account.player[CHAR].crafting[craft])
		if maxsim > 1 then if current == maxsim then color = '|c44FF44' else color = '|cFF4444' end end
		p:GetNamedChild('Headline'):SetText('|t25:25:'..CraftStore.crafticon[craft]..'|t |c44FF44'..RESEARCH[CHAR].known..pip..'|cFF4444'..RESEARCH[CHAR].unknown..pip..'|c999999'..LANG:Get('level')..': '..level..' ('..rank..')|r')
		p:GetNamedChild('Count'):SetText(color..current..' / '..maxsim..'|r')
	end
	
	function self:UpdatePlayerResearch()
		if not RESEARCH[CHAR] then return end
		for _,craft in pairs(crafting) do SetPlayerResearch(craft) end
	end

	local function UpdateTrait(_,craft,line,trait)
		d('UpdateTrait: '..(craft or 'NoCraft')..' - '..(line or 'NoLine')..' - '..(trait or 'NoTrait'))
		SetTrait(craft,line,trait)
		SetIcon(craft,line,trait)
		SetCount(craft,line)
		if not RESEARCH[CHAR] then return end
		local val = GetTrait(craft,line,trait,CHAR) or false
		if val == true or val == false then
			RESEARCH[CHAR][craft][line..'&'..trait] = nil
		elseif val > 0 then
			local _,name,desc = TOOLS:GetTraitInfo(craft,line,trait)
			local _,_,icon = TOOLS:GetLineInfo(craft,line)
			RESEARCH[CHAR][craft][line..'&'..trait] = {' |t23:23:'..icon..'|t  '..name,desc,val}
		end
		SetPlayerResearch(craft)
	end

	function self:GetPlayerResearch()
		RESEARCH[CHAR] = {}
		for _,craft in pairs(crafting) do
			RESEARCH[CHAR][craft] = {}
			local known, unknown = 0, 0
			for line = 1, GetNumSmithingResearchLines(craft) do
				for trait = 1, maxtrait do
					local val = GetTrait(craft,line,trait,CHAR) or false
					if val == true then
						known = known + 1
					elseif val == false then
						unknown = unknown + 1
					elseif val > 0 then
						local _,name,desc = TOOLS:GetTraitInfo(craft,line,trait)
						local _,_,icon = TOOLS:GetLineInfo(craft,line)
						RESEARCH[CHAR][craft][line..'&'..trait] = {' |t23:23:'..icon..'|t  '..name,desc,val}
					end
					SetIcon(craft,line,trait)
				end
				SetCount(craft,line)
				SetInitalActive(craft,line)
			end
			RESEARCH[CHAR].known = known
			RESEARCH[CHAR].unknown = unknown
			SetPlayerResearch(craft)
		end
	end
	
	function self:Init()
		local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}
		local account_init = {
			stock = {},
			stored = {},
			mainchar = false,
			option = {true,true,true,true,true,true,true,true,true,true},
			player = {}
		}
		local character_init = {
			income = { GetDate(), GetCurrentMoney() },
			favorites = { {}, {}, {}, {}, {}, {} },
			style_armor = 1,
			style_active = 2,
			cook_category = 1,
			aspect = 1,
			essence = 1,
			potency = 1,
			potencytype = 1,
			enchant = ITEMTYPE_GLYPH_ARMOR,
			runemode = 'craft',
			solvent = 1,
			trait1 = 1,
			trait2 = 0,
			trait3 = 0,
			nobad = true,
			three = 1,
		}
		CraftStore.account = ZO_SavedVars:NewAccountWide('CS4_Account',1,nil,account_init)
		CraftStore.character = ZO_SavedVars:New('CS4_Character',1,nil,character_init)
		
		if not CraftStore.account.player[SELF] then
			CraftStore.account.player[SELF] = {}
			CraftStore.account.player[SELF].research = {}
			for _,craft in pairs(crafting) do
				CraftStore.account.player[SELF].research[craft] = {}
				for line = 1, GetNumSmithingResearchLines(craft) do
					CraftStore.account.player[SELF].research[craft][line] = {}
					CraftStore.account.player[SELF].research[craft][line].active = false
				end
			end
		end
		
		for _,craft in pairs(crafting) do
			for line = 1, GetNumSmithingResearchLines(craft) do
				for trait = 1, maxtrait do SetTrait(craft,line,trait) end
			end
		end
		SetPlayerLevel()
		SetPlayerMount()
		SetPlayerSkill()
		if CraftStore.account.mainchar then CHAR = CraftStore.account.mainchar end
		CraftStore.account.player[SELF].race = zo_strformat('<<C:1>>',GetUnitRace('player'))
		CraftStore.account.player[SELF].class = GetUnitClassId('player')
		CraftStore.account.player[SELF].level = GetUnitEffectiveLevel('player')
		CraftStore.account.player[SELF].alliance = GetUnitAlliance('player')
		
		local bags = {BAG_BACKPACK, BAG_BANK}
		for _,bag in pairs(bags) do
			bagCache[bag] = {}
			for slot = 0, GetBagSize(bag)-1 do
				local link, uid, id = GetItemLink(bag,slot), Id64ToString(GetItemUniqueId(bag,slot))
				id = TOOLS:SplitLink(link,3)
				bagCache[bag][slot] = { link = link, uid = uid, id = id }
				local a1, a2 = GetItemLinkStacks(link)
				if not CraftStore.account.stock[id] then CraftStore.account.stock[id] = {} end
				if a1 > 0 then CraftStore.account.stock[id][SELF] = a1 else CraftStore.account.stock[id][SELF] = nil end
				if a2 > 0 then CraftStore.account.stock[id]['aa'] = a2 else CraftStore.account.stock[id]['aa'] = nil end
				if next(CraftStore.account.stock[id]) == nil then CraftStore.account.stock[id] = nil end
				local craft,line,trait = TRAIT:FindTrait(link)
				local isSet = GetItemLinkSetInfo(link)
				if craft and line and trait and uid and not isSet then
					local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false }
					local owner = SELF
					if bag == BAG_BANK then owner = LANG:Get('bank') end
					if TOOLS:CompareItem(link, store.link) then CraftStore.account.stored[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid } end
				end
			end
		end

		EM:RegisterForEvent('CraftStore_InventoryMonitor', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InvMonitor)
		EM:RegisterForEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_STARTED, UpdateTrait)
		EM:RegisterForEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, UpdateTrait)
		EM:RegisterForEvent('CraftStore_PlayerLevel', EVENT_LEVEL_UPDATE, SetPlayerLevel)
		EM:RegisterForEvent('CraftStore_PlayerLevel', EVENT_VETERAN_RANK_UPDATE, SetPlayerLevel)
		EM:RegisterForEvent('CraftStore_MountImproved', EVENT_RIDING_SKILL_IMPROVEMENT, SetPlayerMount)
		EM:RegisterForEvent('CraftStore_SkillChanged', EVENT_NON_COMBAT_BONUS_CHANGED, SetPlayerSkill)
		ZO_PreHook('PutPointIntoSkillAbility', SetPlayerSkill)
		ZO_PreHook('ExtractOrRefineSmithingItem', StoreCheck)
		ZO_PreHook('ResearchSmithingTrait', StoreCheck)
	end
 	
	return self
end


local cmdr = false
function CraftStore:Queue()
	if CraftStore.init then
		if IsShiftKeyDown() and not IsPlayerMoving() and not IsUnitInCombat('player') and not cmdr then
			SM:ShowTopLevel(CS4_Commander)
			cmdr = true
		else
			SM:HideTopLevel(CS4_Commander)
			cmdr = false
		end
	end
end


local function DrawPlayer()
	for nr,player in pairs(TOOLS:GetCharacters() do
		local c = WM:CreateControl('$(parent)Player'..nr, CS4_PlayersListScrollChild, CT_BUTTON)
		c:SetAnchor(9,CS4_PlayersListScrollChild,9,-5,32+(nr-1)*26)
		c:SetDimensions(150,25)
		c:SetNormalTexture('CraftStore4/grey.dds')
		c:SetMouseOverTexture('CraftStore4/over.dds')
		c:SetClickSound('Click')
		c:SetHandler('OnMouseEnter', function(self) self:GetNamedChild('Ereaser'):SetHidden(false) end)
		c:SetHandler('OnMouseExit', function(self) self:GetNamedChild('Ereaser'):SetHidden(true) end)
		c:SetHandler('OnClicked', function() PLAYER:SetPlayer(player); PLAYER:GetPlayerResearch() end)
		local e = WM:CreateControl('$(parent)Ereaser', c, CT_BUTTON)
		e:SetAnchor(8,c,8,-5,0)
		e:SetDimensions(16,16)
		e:SetNormalTexture('CraftStore4/cross.dds')
		e:SetMouseOverTexture('CraftStore4/over.dds')
		e:SetHidden(true)
		e:SetClickSound('Click')
		e:SetHandler('OnMouseEnter', function(self) TT:ShowTooltip(self) end)
		e:SetHandler('OnMouseExit', function(self) TT:HideTooltip(self) end)
		e:SetHandler('OnClicked', function() PLAYER:DeleteCharacter(player) end)
		e.cs_data = { info = LANG:Get('deleteChar'), anchor = {e,1,4,0,2} }
	end
end

local function FadePlayers(dir)
	if dir == 1 and not CS4_Players:IsHidden() then dir = 2 end
	local c, size = CS4_Players, 250
	local a = ANIMATION_MANAGER:CreateTimeline()
	local fade = a:InsertAnimation(ANIMATION_ALPHA,c)
	local grow = a:InsertAnimation(ANIMATION_SIZE,c)
	fade:SetDuration(150)
	grow:SetDuration(150)
	grow:SetEasingFunction(ZO_GenerateCubicBezierEase(.25,.5,.4,1.2))
	if dir == 1 then
		c:SetAlpha(0)
		c:SetHidden(false)
		fade:SetAlphaValues(0,1)
		grow:SetStartAndEndHeight(690,690)
		grow:SetStartAndEndWidth(0,size)
	elseif dir == 2 then
		fade:SetAlphaValues(1,0)
		grow:SetStartAndEndHeight(690,690)
		grow:SetStartAndEndWidth(size,0)
		a:SetHandler('OnAnimationEnded', function() c:SetHidden(true) end)
	end
	a:PlayFromStart()
end
CS4_PlayersCloseButton:SetHandler('OnClicked', FadePlayers(2))
CS4_PanelCharacter:SetHandler('OnClicked', FadePlayers(1))

		<TopLevelControl hidden="true" name="CS4_Players">
			<Anchor point="3" relativePoint="9" relativeTo="CS4_Panel" />
			<Dimensions x="0" y="690" />
			<Controls>
				<Backdrop name="$(parent)BG" centerColor="181818" edgeColor="00000000">
					<AnchorFill/>
					<Edge edgeSize="1" />
				</Backdrop>
				<Label name="$(parent)Headline" font="CS4Font" color="FFAA33">
					<Anchor point="1" relativePoint="1" relativeTo="$(parent)" offsetY="5" />
				</Label>
				<Button name="$(parent)CloseButton" clickSound="Click">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-5" offsetY="5" />
					<Dimensions x="25" y="25" />
					<Textures normal="esoui/art/buttons/decline_up.dds" pressed="esoui/art/buttons/decline_down.dds" mouseOver="esoui/art/buttons/decline_over.dds" />
				</Button>
				<Control name="$(parent)List" inherits="ZO_ScrollContainerBase">
					<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="5" offsetY="5" />
					<Dimensions x="240" y="300" />
					<OnInitialized>ZO_Scroll_Initialize(self)</OnInitialized>
					<Controls>
						<Control name="$(parent)ScrollChild">
							<OnInitialized>self:SetParent(self:GetParent():GetNamedChild("Scroll"));self:SetAnchor(3,nil,3,0,0)</OnInitialized>
						</Control>
					</Controls>
				</Control>
				<Button name="$(parent)TrackingStyle" clickSound="Click">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-5" offsetY="5" />
					<Dimensions x="240" y="25" />
				</Button>
				<Button name="$(parent)TrackingRecipe" clickSound="Click">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-5" offsetY="5" />
					<Dimensions x="240" y="25" />
				</Button>
				<Button name="$(parent)Mainchar" clickSound="Click">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-5" offsetY="5" />
					<Dimensions x="240" y="25" />
				</Button>
			</Controls>
		</TopLevelControl>

	function self:ToChat(text) StartChatInput(CHAT_SYSTEM.textEntry:InsertText(text)) end
