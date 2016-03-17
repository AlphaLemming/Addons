-- ZO_Alchemy_IsThirdAlchemySlotUnlocked()

CS = {}

function CS.FLASK()
    local self = {
        noBad = true,
        three = true,
        selectedSolvent = nil
    }
    local trait, plant, result, found = {0,0,0}, {0,0,0}, {}, {}
    local solvent = {883,1187,4570,23265,23266,23267,23268,64500,64501}
    local reagent = {
		{30165,2,14,12,23}, --1
		{30158,9,3,18,13},  --2
		{30155,6,8,1,22},   --3
		{30152,18,2,9,4},   --4
		{30162,7,5,16,11},  --5
		{30148,4,10,1,23},  --6
		{30149,16,2,7,6},   --7
		{30161,3,9,2,24},   --8
		{30160,17,1,10,3},  --9
		{30154,10,4,17,12}, --10
		{30157,5,7,2,21},   --11
		{30151,2,4,6,20},   --12
		{30164,1,3,5,19},   --13
		{30159,11,22,24,19},--14
		{30163,15,1,8,5},   --15
		{30153,13,21,23,19},--16
		{30156,8,6,15,12},  --17
		{30166,1,13,11,20}  --18
	}
    local path = 'esoui/art/icons/alchemy/crafting_alchemy_trait_'
    local icon = {
		'restorehealth','ravagehealth',
		'restoremagicka','ravagemagicka',
		'restorestamina','ravagestamina',
		'increaseweaponpower','lowerweaponpower',
		'increasespellpower','lowerspellpower',
		'weaponcrit','lowerweaponcrit',
		'spellcrit','lowerspellcrit',
		'increasearmor','lowerarmor',
		'increasespellresist','lowerspellresist',
		'unstoppable','stun',
		'speed','reducespeed',
		'invisible','detection',
	}

    local function Quality(nr,a,hex)
	    local quality = {[0]={0.65,0.65,0.65,a},[1]={1,1,1,a},[2]={0.17,0.77,0.05,a},[3]={0.22,0.57,1,a},[4]={0.62,0.18,0.96,a},[5]={0.80,0.66,0.10,a}}
	    local qualityhex = {[0]='B3B3B3',[1]='FFFFFF',[2]='2DC50E',[3]='3A92FF',[4]='A02EF7',[5]='EECA2A'}
	    if hex then return qualityhex[nr] else return unpack(quality[nr]) end
    end

    local function SplitLink(link,nr)
    	local split = {SplitString(':', link)}
    	if split[nr] then return tonumber(split[nr]) else return false end
    end

    function self.GetTraitIcon(nr)
	    return path..icon[nr]..'.dds'
    end

    function self.GetReagent(nr)
        local link, icon, bag, bank
        link = ('|H1:item:%u:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h'):format(reagent[nr][1])
        icon = GetItemLinkInfo(link)
        bag, bank = GetItemLinkStacks(link)
        return icon, (bag + bank), link
    end

    local function GetReagentBagSlot(nr)
    	local bag, id = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK,BAG_BANK), reagent[nr][1]
    	for _,data in pairs(bag) do
    		local scanid = SplitLink(GetItemLink(data.bagId,data.slotIndex),3)
    		if id == scanid then return data.bagId, data.slotIndex end
    	end
    end

    function self.SetTraits(traits)
        trait = traits
    end

    local function IsBad(val)
    	if val%2 == 0 and val < 24 then return true end
    	return false
    end

    local function GetAntiTrait(val)
    	if val%2 == 0 then return val - 1 end
    	return val + 1
    end

    local function GetTraits()
    	local cur, acur
    	found = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    	for _,x in pairs(plant) do
    		for a = 2,5 do
    			cur = reagent[x][a]
    			acur = GetAntiTrait(cur)
				found[cur] = found[cur] + 1
				found[acur] = found[acur] - 1
    		end
    	end
    	if self.noBad then for x,y in pairs(found) do if IsBad(x) and y > 1 then found = false; return end end end
    end

    local function SetResult()
        local ok, t = {false,false,false}
        GetTraits()
        if found then
            for i = 1,3 do
                t = trait[i]
                if t then if found[t] and found[t] > 1 then ok[i] = true end
                else ok[i] = true end
            end 
            if ok[1] and ok[2] and ok[3] then
                for nr,x in pairs(found) do if x < 2 then found[nr] = nil end end
                table.insert(result,{plant,found})
            end
        end
    end
    
    function self.GetReagentCombination()
    	local size = #reagent
        for x = 1,size do
            for y = x+1, size do
                plant = {x,y}
                SetResult()
                if self.three then
                    for z = y+1, size do
                        plant = {x,y,z}
                        SetResult()
                    end
                end
            end
        end
        for nr,x in pairs(result) do
            print(nr..') Reagent-Numbers: '..x[1][1]..', '..x[1][2]..', '..(x[1][3] or '-'))
            local t = nr..') Traits: '
            for y,z in pairs(x[2]) do t = t..(y or '-')..' ['..z..'], ' end
            print(t)
            print('--')
        end
    end

    local function GetPotion(row)
        GetReagentCombination()
        local rb, rs, slot3, traits, link, color = {}, {}, false, {}
        local good, bad = {{1,1,1,1},{0,0.8,0,1},{0.2,1,0.2,1}}, {{1,1,1,1},{0.8,0,0,1},{1,0.2,0.2,1}}
        
        for x,_ in pairs(trait) do rb[x], rs[x] = GetReagentBagSlot(result[row][1][x]) end
        rb[4], rs[4] = GetReagentBagSlot(solvent[self.selectedSolvent])
        
        if self.three and rb[3] and rs[3] then slot3 = true elseif not self.three then slot3 = true end
            
        if rb[4] and rs[4] and rb[1] and rs[1] and rb[2] and rs[2] and slot3 then
            local _, icon = GetAlchemyResultingItemInfo(rb[4],rs[4],rb[1],rs[1],rb[2],rs[2],rb[3],rs[3])
            link = GetAlchemyResultingItemLink(rb[4],rs[4],rb[1],rs[1],rb[2],rs[2],rb[3],rs[3])
            for y,z in pairs(result[row][2]) do
                if IsBad(y) then color = bad else color = good end
                table.insert(traits,{self.GetTraitIcon(y),color[z]})
            end
            return true, zo_strformat('|t32:32:<<1>>|t <<C:2>>', icon, link), link, rb, rs, traits
        else
            for y,x in pairs(plant) do
                local icon, _, link = self.GetReagent(x)
                item = item..zo_strformat('|t32:32:<<1>>|t', icon)
                color = color..zo_strformat('<<C:1>>', link)
                if y < #plant then
                    item = item..' + '
                    color = color..'\n'
                end
            end
            return false, item, color
        end
    end

    function self.GetAllPotion()
        for row,_ in ipairs(result) do
            local isPotion, item, link, rb, rs, traits = GetPotion(row)
            if isPotion then d(item) else d(item) end
        end
    end

    return self
end

flask = CS.FLASK()
flask.SetTraits({1,3,5})
flask.GetReagentCombination()
--flask.GetAllPotion()


	chest		'|H1:item:46117:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h'
	head		'|H1:item:46116:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h'
	legs		'|H1:item:46120:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h'
	
for styleItemIndex = 1, GetNumSmithingStyleItems() do
    local itemName, _, _, meetsUsageRequirement, itemStyle = GetSmithingStyleItemInfo(styleItemIndex)
    local itemLink = GetSmithingStyleItemLink(styleItemIndex, LINK_STYLE_DEFAULT)
    if meetsUsageRequirement and itemStyle ~= ITEMSTYLE_UNIVERSAL then
        local styleName = GetString("SI_ITEMSTYLE", itemStyle)
        local associatedStone = zo_strformat(SI_TOOLTIP_ITEM_NAME, itemName)
    end
end



----

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
	
	function self:SetIcon(craft,line,trait)
		if not craft or not line or not trait then return end
		local CHAR = CSP:GetPlayer()
		local traitname = GetString('SI_ITEMTRAITTYPE',GetSmithingResearchLineTraitInfo(craft,line,trait))
		local c = WM:GetControlByName('CS4_PanelCraft'..craft..'Line'..line..'Trait'..trait)
		local known = CS.account.crafting.research[SELECTED_PLAYER][craft][line][trait] or false
		local store = CS.account.crafting.stored[craft][line][trait] or { link = false, owner = false }
		local now, tip = GetTimeStamp(), ''
		local function CountTraits()
			local count = 0
			for x, trait in pairs(CS.account.crafting.research[SELECTED_PLAYER][craft][line]) do
				if trait == true then count = count + 1 end
			end
			return count
		end
		for z, char in pairs(CSP:GetCharacters()) do
			local val = CS.account.crafting.research[char][craft][line][trait] or false
			if val == true then
				tip = tip..'\n|t20:20:esoui/art/buttons/accept_up.dds|t |c00FF00'..char..'|r'
			elseif val == false then
				tip = tip..'\n|t20:20:esoui/art/buttons/decline_up.dds|t |cFF1010'..char..'|r'
			elseif val and val > 0 then
				if char == CURRENT_PLAYER then
					local dur,remain = GetSmithingResearchLineTraitTimes(craft,line,trait)
					tip = tip..'\n|t23:23:esoui/art/mounts/timer_icon.dds|t |c66FFCC'..char..' ('..CS.GetTime(remain)..')|r'
				else
					tip = tip..'\n|t23:23:esoui/art/mounts/timer_icon.dds|t |c66FFCC'..char..' ('..CS.GetTime(GetDiffBetweenTimeStamps(val,now))..')|r'
				end
			end
		end
		control:GetParent().data = { info = '|cFFFFFF'..traitname..'|r'..tip..'\n'..L.TT[6] }
		if known == false then
			control:SetColor(1,0,0,1)
			control:SetTexture('esoui/art/buttons/decline_up.dds')
			if store.link and store.owner then
				local isSet = GetItemLinkSetInfo(store.link)
				local mark = true
				if not CS.account.option[14] and isSet then mark = false end
				if mark then 
					tip = '\n|t20:20:esoui/art/buttons/pointsplus_up.dds|t |cE8DFAF'..store.owner..'|r'..tip
					control:SetColor(1,1,1,1)
					control:SetTexture('esoui/art/buttons/pointsplus_up.dds')
					control:GetParent().data = { link = store.link, addline = {tip}, research = {craft,line,trait,store.owner} }
				end
			end
		elseif known == true then
			control:SetColor(0,1,0,1)
			control:SetTexture('esoui/art/buttons/accept_up.dds')
		else
			control:SetColor(0.4,1,0.8,1)
			control:SetTexture('esoui/art/mounts/timer_icon.dds')
		end
		WM:GetControlByName('CS_PanelCraft'..craft..'Line'..line..'Count'):SetText(CountTraits())
	end
	
	return self
end

function CraftStore:PLAYER()
	self = {}
	local EM = EVENT_MANAGER
	local SELF, CHAR = GetUnitName('player')
	
	function self:Init()
		local crafting = {CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING}
		account_init = {
			stock = {},
			stored = {},
			research = {},
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
				crafting = {}
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
		CraftStore.account = ZO_SavedVars:NewAccountWide('CS4_Account',1,nil,account_init)
		CraftStore.character = ZO_SavedVars:New('CS4_Character',1,nil,character_init)
		SetPlayerLevel()
		SetPlayerMount()
		SetPlayerSkill()
		if CraftStore.account.mainchar then CHAR = CraftStore.account.mainchar
		else CHAR = SELF end
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

	function self:GetTrait(craft,line,trait)
		local t,_ = CraftStore.account[CHAR].research[craft][line][trait]
		if t ~= false and t ~= true	and t > 0 then _,t = GetSmithingResearchLineTraitTimes(craft,line,trait) end
		return t
	end	

	local function SetStored(craft,line,trait)
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
	SHARED_INVENTORY:RegisterCallback('SlotAdded',OnSlotAdded)
	SHARED_INVENTORY:RegisterCallback('SlotRemoved',OnSlotRemoved)
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
	
	return self
end
