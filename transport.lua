function CraftStore:PLAYER()
	self = {}
	local bagCache = {}
	local EM = EVENT_MANAGER
	local SELF, CHAR = GetUnitName('player'), GetUnitName('player')
	-- local PANEL = CraftStore:PANEL()
	local TRAITS = CraftStore:TRAITS()
	local LANG = CraftStore:LANGUAGE()
	local TOOLS = CraftStore:TOOLS()
	
	function self:SetPlayer(player) CHAR = player end
	
	function self:SetPlayerStyles(val) CraftStore.account.player[CHAR].styles = val or false end
	
	function self:SetPlayerRecipes(val) CraftStore.account.player[CHAR].recipes = val or false end
	
	function self:SetPlayerAnnounced(player,val) CraftStore.account.player[player].anncounced = val or false end
	
	function self:GetSelf(player) return player == SELF end
	
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
		-- local craft, line, trait = TRAITS:FindTrait(link)
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

	local function UpdateTrait(_,craft,line,trait)
		d('UpdateTrait: '..(craft or 'NoCraft')..' - '..(line or 'NoLine')..' - '..(trait or 'NoTrait')..' - '..(CraftStore.account.stored[craft..'&'..line..'&'..trait].link or 'NoLink'))
		local _,_,known = GetSmithingResearchLineTraitInfo(craft,line,trait)
		local _,dur = GetSmithingResearchLineTraitTimes(craft,line,trait)
		if not known and dur and dur > 0 then known = dur end
		CraftStore.account.player[SELF].research[craft][line][trait] = known or false
		-- PANEL:UpdateTrait(craft,line,trait)
	end

	function self:GetTrait(craft,line,trait,player)
		if player and not player ~= SELF then
			return CraftStore.account.player[player].research[craft][line][trait] or false
		else
			local t,_ = CraftStore.account.player[SELF].research[craft][line][trait]
			if t ~= false and t ~= true	and t > 0 then _,t = GetSmithingResearchLineTraitTimes(craft,line,trait) end
			return t
		end
	end	

	function self:GetTraitSummary(craft,line,trait)
		local tip = {}
		for _,char in pairs(TOOLS:GetCharacters()) do
			local val = self:GetTrait(craft,line,trait,char)
			if val == true then table.insert(tip,'|t20:20:CraftStore4/tick.dds|t |c00FF00'..char..'|r')
			elseif val == false then table.insert(tip,'|t20:20:CraftStore4/cross.dds|t |cFF1010'..char..'|r')
			elseif val and val > 0 then table.insert(tip,'|t23:23:CraftStore4/time.dds|t |c66FFCC'..char..' ('..TOOLS:GetTime(val)..')|r') end
		end
		return table.concat(tip,'\n')
	end

	function self:GetStored(craft,line,trait) return CraftStore.account.stored[craft..'&'..line..'&'..trait] or false end		

	local function InvMonitor(_,bag,slot)
        if bag == 0 or bag > 2 then return end
		local link, uid, id, gone = nil, nil, nil, false
		link = GetItemLink(bag,slot)
		if not link then
			link = bagCache[bag][slot].link
			gone = true
		end
		uid = Id64ToString(GetItemUniqueId(bag,slot)) or bagCache[bag][slot].uid
		id = TOOLS:SplitLink(link,3) or bagCache[bag][slot].id
		d('InvMonitor: '..(bag or 'NoBag')..' - '..(slot or 'NoSlot')..' - '..(link or 'NoLink')..' # IsGone: '..gone)
		if link and link ~= '' then bagCache[bag][slot] = { link = link, uid = uid, id = id } end
		local a1, a2 = GetItemLinkStacks(link)
		if not CraftStore.account.stock[id] then CraftStore.account.stock[id] = {} end
		if a1 > 0 then CraftStore.account.stock[id][SELF] = a1 else CraftStore.account.stock[id][SELF] = nil end
		if a2 > 0 then CraftStore.account.stock[id]['aa'] = a2 else CraftStore.account.stock[id]['aa'] = nil end
		if next(CraftStore.account.stock[id]) == nil then CraftStore.account.stock[id] = nil end
		local craft,line,trait = TRAITS:FindTrait(link)
		if craft and line and trait and uid then
			local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false }
			local owner = SELF
			if bag == BAG_BANK then owner = LANG:Get('bank') end
			if gone then
				if bagCache[bag][slot].uid == store.uid then CraftStore.account.stored[craft..'&'..line..'&'..trait] = nil end
			elseif TOOLS:CompareItem(link, store.link) then
				CraftStore.account.stored[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid }
			end
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
		CraftStore.account.player[SELF] = {}
		CraftStore.account.player[SELF].research = {}
		for _,craft in pairs(crafting) do
			CraftStore.account.player[SELF].research[craft] = {}
			for line = 1, GetNumSmithingResearchLines(craft) do
				CraftStore.account.player[SELF].research[craft][line] = {}
				CraftStore.account.player[SELF].research[craft][line].active = false
				local _,_,maxtraits = GetSmithingResearchLineInfo(craft,line)
				for trait = 1, maxtraits do SetTrait(craft,line,trait) end
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
		
		EM:RegisterForEvent('CraftStore_InventoryMonitor', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InvMonitor)
		EM:RegisterForEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_STARTED, UpdateTrait)
		EM:RegisterForEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, UpdateTrait)
		EM:RegisterForEvent('CraftStore_PlayerLevel', EVENT_LEVEL_UPDATE, SetPlayerLevel)
		EM:RegisterForEvent('CraftStore_PlayerLevel', EVENT_VETERAN_RANK_UPDATE, SetPlayerLevel)
		EM:RegisterForEvent('CraftStore_MountImproved', EVENT_RIDING_SKILL_IMPROVEMENT, SetPlayerMount)
		EM:RegisterForEvent('CraftStore_SkillChanged', EVENT_NON_COMBAT_BONUS_CHANGED, SetPlayerSkill)
		ZO_PreHook('PutPointIntoSkillAbility', SetPlayerSkill)

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
				local craft,line,trait = TRAITS:FindTrait(link)
				if craft and line and trait and uid then
					local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false }
					local owner = SELF
					if bag == BAG_BANK then owner = LANG:Get('bank') end
					if TOOLS:CompareItem(link, store.link) then CraftStore.account.stored[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid } end
				end
			end
		end
		
		function self:GetBagCache() return bagCache end
	end
 	
	return self
end
