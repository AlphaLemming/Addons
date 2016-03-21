CraftStore = {
	name = 'CraftStore4',
	version = '4.00',
	author = 'AlphaLemming',
	account, character
}

function CraftStore:PANEL()
	self = {}
	local WM = WINDOW_MANAGER
	local CSP = CraftStore:PLAYER()
	local CSL = CraftStore:LANGUAGE()
	
	function self:SetIcon(craft,line,trait)
		if not craft or not line or not trait then return end
		local traitname = GetString('SI_ITEMTRAITTYPE',GetSmithingResearchLineTraitInfo(craft,line,trait))
		local known, store = CSP:GetTrait(craft,line,trait), CSP:GetStored(craft,line,trait)
		local count, tip = CSP:GetTraitSummary(craft,line,trait)
		local c = WM:GetControlByName('CS4_PanelCraft'..craft..'Line'..line..'Trait'..trait)
		c.data = { info = '|cFFFFFF'..traitname..'|r'..tip..'\n'..CSL:String(6) }
		if known == false then
			if store then
				tip = '\n|t20:20:CraftStore4/stored.dds|t |cE8DFAF'..store.owner..'|r'..tip
				c:SetNormalTexture('CraftStore4/stored.dds')
				c.data = { link = store.link, addline = {tip} }
			else c:SetNormalTexture('CraftStore4/unknown.dds') end
		elseif known == true then c:SetNormalTexture('CraftStore4/known.dds')
		else c:SetNormalTexture('CraftStore4/timer.dds') end
		WM:GetControlByName('CS4_PanelCraft'..craft..'Line'..line..'Count'):SetText(count)
	end
	
	return self
end

function CraftStore:PLAYER()
	self = {}
	local EM = EVENT_MANAGER
	local SELF, CHAR = GetUnitName('player')
	local CSPL = CraftStore:PANEL()
	local CST = CraftStore:TRAITS()
	
	function self:Init(version)
		if not version then version = 1 end
		local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}
		account_init = {
			stock = {},
			stored = {},
			option = {true,true,true,false},
			player = {
				race = zo_strformat('<<C:1>>',GetUnitRace('player')),
				class = GetUnitClassId('player'),
				level = 1,
				elevel = GetUnitEffectiveLevel('player'),
				alliance = GetUnitAlliance('player'),
				styles = false,
				recipes = false,
				speed = 0,
				stamina = 0,
				capacity = 0,
				training = 0,
				anncounced = false,
				crafting = {},
				research = {},
				recipe = {},
				style = {},
			}
		}
		for _,craft in ipairs(crafting) do
			account_init.research[craft] = {}
			for line = 1, GetNumSmithingResearchLines(craft) do
				account_init.research[craft][line] = {}
				account_init.research[craft].active = false
				local _,_,maxlines = GetSmithingResearchLineInfo()
				for trait = 1, maxtraits do SetTrait(craft,line,trait) end
			end
		end
		CraftStore.account = ZO_SavedVars:NewAccountWide('CS4_Account',version,nil,account_init)
		CraftStore.character = ZO_SavedVars:New('CS4_Character',version,nil,character_init)
		SetPlayerLevel()
		SetPlayerMount()
		SetPlayerSkill()
		if CraftStore.account.mainchar then CHAR = CraftStore.account.mainchar else CHAR = SELF end
	end

	function self:SetPlayer(player) CHAR = player end
	
	function self:SetPlayerStyles(val) CraftStore.account.player[CHAR].styles = val or false end
	
	function self:SetPlayerRecipes(val) CraftStore.account.player[CHAR].recipes = val or false end
	
	function self:SetPlayerAnnounced(player,val) CraftStore.account.player[player].anncounced = val or false end
	
	function self:GetPlayer() return CHAR end
	
	function self:GetPlayerValues() return CraftStore.account.player[CHAR] end
	
	function self:GetPlayerStyles() return CraftStore.account.player[CHAR].styles or false end
	
	function self:GetPlayerRecipes() return CraftStore.account.player[CHAR].recipes or false end
	
	function self:GetPlayerAnnounced(player) return CraftStore.account.player[player].anncounced or false end
	
	function self:GetCharacters()
		local function ts(t)
			local oi = {}
			for key in pairs(t) do table.insert(oi,key) end
			return table.sort(oi)
		end
		return ts(CraftStore.account.player)
	end
	
	local function SetPlayerLevel() CraftStore.account.player[SELF].level = GetUnitLevel('player') + (GetUnitVeteranRank('player') - 1) end
	
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
		local function GetBonus(bonus,craft)
			local level = GetNonCombatBonus(bonus) or 1
			local _,rank = GetSkillLineInfo(unpack(GetCraftingSkillLineIndices(craft)))
			return {rank, level, GetMaxSimultaneousSmithingResearch(craft) or 1}
		end
		CraftStore.account.player[SELF].crafting = {
			[CRAFTING_TYPE_BLACKSMITHING] = GetBonus(NON_COMBAT_BONUS_BLACKSMITHING_LEVEL, CRAFTING_TYPE_BLACKSMITHING),
			[CRAFTING_TYPE_CLOTHIER] = GetBonus(NON_COMBAT_BONUS_CLOTHIER_LEVEL, CRAFTING_TYPE_CLOTHIER),
			[CRAFTING_TYPE_ENCHANTING] = GetBonus(NON_COMBAT_BONUS_ENCHANTING_LEVEL, CRAFTING_TYPE_ENCHANTING),
			[CRAFTING_TYPE_ALCHEMY] = GetBonus(NON_COMBAT_BONUS_ALCHEMY_LEVEL, CRAFTING_TYPE_ALCHEMY),
			[CRAFTING_TYPE_PROVISIONING] = GetBonus(NON_COMBAT_BONUS_PROVISIONING_LEVEL, CRAFTING_TYPE_PROVISIONING),
			[CRAFTING_TYPE_WOODWORKING] = GetBonus(NON_COMBAT_BONUS_WOODWORKING_LEVEL, CRAFTING_TYPE_WOODWORKING)
		}			
	end

	local function SetTrait(craft,line,trait)
		local _,_,known = GetSmithingResearchLineTraitInfo(craft,line,trait)
		local _,dur = GetSmithingResearchLineTraitTimes(craft,line,trait)
		if not known and dur > 0 then known = dur end
		CraftStore.account.research[SELF][craft][line][trait] = known
	end

	function self:GetTrait(craft,line,trait,player)
		if not player then player = CHAR end
		local t,_ = CraftStore.account[player].research[craft][line][trait] or false
		if t ~= false and t ~= true	and t > 0 then _,t = GetSmithingResearchLineTraitTimes(craft,line,trait) end
		return t
	end	

	local function GetTraitCount(craft,line)
		local count = 0
		for _,trait in pairs(CraftStore.account.research[CHAR][craft][line]) do
			if trait == true then count = count + 1 end
		end
		return count
	end

	function GetTime(seconds)
		if seconds and seconds > 0 then
			local d = math.floor(seconds / 86400)
			local h = math.floor((seconds - d * 86400) / 3600)
			local m = math.floor((seconds - d * 86400 - h * 3600) / 60)
			local s = math.floor((seconds - d * 86400 - h * 3600 - m * 60))
			if d > 0 then return ('%ud %02u:%02u:%02u'):format(d,h,m,s)
			else return ('%02u:%02u:%02u'):format(h,m,s) end
		else return '|t20:20:CraftStore4/tick.dds|t' end
	end
	
	function self:GetTraitSummary(craft,line,trait)
		local count = self:GetTraitCount(craft,line)
		for _,char in pairs(self:GetCharacters()) do
			local val = self:GetTrait(craft,line,trait,char)
			if val == true then tip = tip..'\n|t20:20:esoui/art/buttons/accept_up.dds|t |c00FF00'..char..'|r'
			elseif val == false then tip = tip..'\n|t20:20:esoui/art/buttons/decline_up.dds|t |cFF1010'..char..'|r'
			elseif val and val > 0 then tip = tip..'\n|t23:23:esoui/art/mounts/timer_icon.dds|t |c66FFCC'..char..' ('..GetTime(val)..')|r' end
		end
		return count, tip
	end

	local function SetStored(_,_,data)
		if data.bagId > 2 then return end
		local link, uid = GetItemLink(data.bagId,data.slotId), Id64ToString(data.uniqueId)
		local a1, a2 = GetItemLinkStacks(link)
		data.cs_link = link
		if not CraftStore.account.stock[uid] then CraftStore.account.stock[uid] = {} end
		if a1 > 0 then CraftStore.account.stock[uid][SELF] = a1 else CraftStore.account.stock[uid][SELF] = nil end
		if a2 > 0 then CraftStore.account.stock[uid][1] = a2 else CraftStore.account.stock[uid][1] = nil end

		local craft,line,trait = CST:FindTrait(link)
		local store = CraftStore.account.stored[craft][line][trait]
		
		local function CompareItem(link1,link2)
			if not store.link then return true else
			if GetItemLinkQuality(link1) < GetItemLinkQuality(link2) then return true end
			if GetItemLinkRequiredLevel(link1) < GetItemLinkRequiredLevel(link2) then return true end
			if GetItemLinkRequiredVeteranRank(link1) < GetItemLinkRequiredVeteranRank(link2) then return true end
			return false
		end
		
		if craft and line and trait then
			if action == 'added' then
				local owner = SELF
				if data.bagId == BAG_BANK then owner = CSL:String(bank) end
				if CompareItem(link, store.link) then
					CraftStore.account.stored[craft][line][trait] = { link = link, owner = owner, id = data.uid }
				end
			end
			if action == 'removed' and CS.account.crafting.stored[craft][line][trait].id == data.uid then
				CraftStore.account.stored[craft][line][trait] = nil
			end
			CSPL:SetIcon(craft,line,trait)
		end
	end
	
	function self:GetStored(craft,line,trait)
		local s = CraftStore.account.stored
		if s[craft] and s[craft][line] and s[craft][line][trait] then return s[craft][line][trait] end
		return false
	end		

	EM:RegisterEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_STARTED, SetTrait)
	EM:RegisterEvent('CraftStore_TraitUpdate', EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, SetTrait)
	EM:RegisterEvent('CraftStore_PlayerLevel', EVENT_LEVEL_UPDATE, SetPlayerLevel)
	EM:RegisterEvent('CraftStore_PlayerLevel', EVENT_VETERAN_RANK_UPDATE, SetPlayerLevel)
	EM:RegisterEvent('CraftStore_MountImproved', EVENT_RIDING_SKILL_IMPROVEMENT, SetPlayerMount)
	ZO_PreHook('PutPointIntoSkillAbility', SetPlayerSkill)
	ZO_PreHook('ChooseAbilityProgressionMorph', SetPlayerSkill)
	SHARED_INVENTORY:RegisterCallback('SlotAdded',SetStored)
	SHARED_INVENTORY:RegisterCallback('SlotRemoved',UnsetStored)
	-- ZO_PreHook('ZO_Skills_PurchaseAbility', SetPlayerSkill)
	-- ZO_PreHook('ZO_Skills_UpgradeAbility', SetPlayerSkill)
	-- ZO_PreHook('ZO_Skills_MorphAbility', SetPlayerSkill)
	
	return self
end

function CraftStore:DRAW()
	self = {}
	local WM = WINDOW_MANAGER
	
	function self:Button(name, parent)
		local c = WM:GetControlByName(name) or WM:CreateControl(name, parent, CT_BUTTON)
		c:SetDimensions(40,40)
		c:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		c:SetVerticalAlignment(TEXT_ALIGN_CENTER)
		c:SetClickSound('Click')
		c:SetNormalTexture('CraftStore/grey.dds')
		c:SetMouseOverTexture('CraftStore/light.dds')
		c:SetFont('CSFont')
		c:SetNormalFontColor(1,1,1,1)
		c:SetMouseOverFontColor(1,0.66,0.2,1)
		return c
	end
	
	return self
end

function CraftStore:TRAITS()
	self = {}
	local armor_trait = {
		[ITEM_TRAIT_TYPE_ARMOR_STURDY] = 1,
		[ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE] = 2,
		[ITEM_TRAIT_TYPE_ARMOR_REINFORCED] = 3,
		[ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED] = 4,
		[ITEM_TRAIT_TYPE_ARMOR_TRAINING] = 5,
		[ITEM_TRAIT_TYPE_ARMOR_INFUSED] = 6,
		[ITEM_TRAIT_TYPE_ARMOR_EXPLORATION] = 7,
		[ITEM_TRAIT_TYPE_ARMOR_DIVINES] = 8,
		[ITEM_TRAIT_TYPE_ARMOR_NIRNHONED] = 9
	}
	local weapon_trait = {
		[ITEM_TRAIT_TYPE_WEAPON_POWERED] = 1,
		[ITEM_TRAIT_TYPE_WEAPON_CHARGED] = 2,
		[ITEM_TRAIT_TYPE_WEAPON_PRECISE] = 3,
		[ITEM_TRAIT_TYPE_WEAPON_INFUSED] = 4,
		[ITEM_TRAIT_TYPE_WEAPON_DEFENDING] = 5,
		[ITEM_TRAIT_TYPE_WEAPON_TRAINING] = 6,
		[ITEM_TRAIT_TYPE_WEAPON_SHARPENED] = 7,
		[ITEM_TRAIT_TYPE_WEAPON_WEIGHTED] = 8,
		[ITEM_TRAIT_TYPE_WEAPON_NIRNHONED] = 9
	}
	local armor = {
		[ARMORTYPE_HEAVY] = {
			[EQUIP_TYPE_CHEST] = {CRAFTING_TYPE_BLACKSMITHING,8},
			[EQUIP_TYPE_FEET] = {CRAFTING_TYPE_BLACKSMITHING,9},
			[EQUIP_TYPE_HAND] = {CRAFTING_TYPE_BLACKSMITHING,10},
			[EQUIP_TYPE_HEAD] = {CRAFTING_TYPE_BLACKSMITHING,11},
			[EQUIP_TYPE_LEGS] = {CRAFTING_TYPE_BLACKSMITHING,12},
			[EQUIP_TYPE_SHOULDERS] = {CRAFTING_TYPE_BLACKSMITHING,13},
			[EQUIP_TYPE_WAIST] = {CRAFTING_TYPE_BLACKSMITHING,14}
		},
		[ARMORTYPE_MEDIUM] = {
			[EQUIP_TYPE_CHEST] = {CRAFTING_TYPE_CLOTHIER,8},
			[EQUIP_TYPE_FEET] = {CRAFTING_TYPE_CLOTHIER,9},
			[EQUIP_TYPE_HAND] = {CRAFTING_TYPE_CLOTHIER,10},
			[EQUIP_TYPE_HEAD] = {CRAFTING_TYPE_CLOTHIER,11},
			[EQUIP_TYPE_LEGS] = {CRAFTING_TYPE_CLOTHIER,12},
			[EQUIP_TYPE_SHOULDERS] = {CRAFTING_TYPE_CLOTHIER,13},
			[EQUIP_TYPE_WAIST] = {CRAFTING_TYPE_CLOTHIER,14}
		},
		[ARMORTYPE_LIGHT] = {
			[EQUIP_TYPE_CHEST] = {CRAFTING_TYPE_CLOTHIER,1},
			[EQUIP_TYPE_FEET] = {CRAFTING_TYPE_CLOTHIER,2},
			[EQUIP_TYPE_HAND] = {CRAFTING_TYPE_CLOTHIER,3},
			[EQUIP_TYPE_HEAD] = {CRAFTING_TYPE_CLOTHIER,4},
			[EQUIP_TYPE_LEGS] = {CRAFTING_TYPE_CLOTHIER,5},
			[EQUIP_TYPE_SHOULDERS] = {CRAFTING_TYPE_CLOTHIER,6},
			[EQUIP_TYPE_WAIST] = {CRAFTING_TYPE_CLOTHIER,7}
		}
	}
	local weapon = {
		[WEAPONTYPE_AXE] = {CRAFTING_TYPE_BLACKSMITHING,1},
		[WEAPONTYPE_HAMMER] = {CRAFTING_TYPE_BLACKSMITHING,2},
		[WEAPONTYPE_SWORD] = {CRAFTING_TYPE_BLACKSMITHING,3},
		[WEAPONTYPE_TWO_HANDED_AXE] = {CRAFTING_TYPE_BLACKSMITHING,4},
		[WEAPONTYPE_TWO_HANDED_HAMMER] = {CRAFTING_TYPE_BLACKSMITHING,5},
		[WEAPONTYPE_TWO_HANDED_SWORD] = {CRAFTING_TYPE_BLACKSMITHING,6},
		[WEAPONTYPE_DAGGER] = {CRAFTING_TYPE_BLACKSMITHING,7},
		[WEAPONTYPE_BOW] = {CRAFTING_TYPE_WOODWORKING,1},
		[WEAPONTYPE_FIRE_STAFF] = {CRAFTING_TYPE_WOODWORKING,2},
		[WEAPONTYPE_FROST_STAFF] = {CRAFTING_TYPE_WOODWORKING,3},
		[WEAPONTYPE_LIGHTNING_STAFF] = {CRAFTING_TYPE_WOODWORKING,4},
		[WEAPONTYPE_HEALING_STAFF] = {CRAFTING_TYPE_WOODWORKING,5},
		[WEAPONTYPE_SHIELD] = {CRAFTING_TYPE_WOODWORKING,6},
	}

	function self:GetArmorTraits() return armor_trait end
	
	function self:GetWeaponTraits() return weapon_trait end
	
	function self:FindTrait(link)
		if not link then return false end
		local at, wt = GetItemLinkArmorType(link), GetItemLinkWeaponType(link)
		if at ~= ARMORTYPE_NONE then
			local trait = GetItemLinkTraitInfo(link)
			if armor_trait[trait] then
				local equip = GetItemLinkEquipType(link)
				local craft, line = unpack(armor[at][equip]) or false, false
				if craft and line and trait then return craft, line, armor_trait[trait] end
			end			
		elseif wt ~= WEAPONTYPE_NONE then
			local trait = GetItemLinkTraitInfo(link)
			if weapon_trait[trait] or (wt == WEAPONTYPE_SHIELD and armor_trait[trait]) then
				local craft, line = unpack(weapon[wt]) or false, false
				if craft and line and trait then
					if wt == WEAPONTYPE_SHIELD then return craft, line, armor_trait[trait]
					else return craft, line, weapon_trait[trait] end
				end
			end
		end
		return false
	end
	
	function self:IsTraitNeeded(link)
		local needer = ''
		local craft, line, trait = self:FindTrait(link)
		if craft and line and trait then
			for _,char in pairs(self:GetCharacters()) do
				if not 
			end
		end
		return needer
	end
	
	return self
end
