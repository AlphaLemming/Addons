-- ZO_Alchemy_IsThirdAlchemySlotUnlocked()

CS = {}

function CS.FLASK()
    local self = {
        noBad, three = false, true
    }
    local trait, plant, result, found = {}, {}, {}, {}
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

    function self.GetReagentBagSlot(nr)
    	local bag, id = SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK,BAG_BANK), reagent[nr][1]
    	for _,data in pairs(bag) do
    		local scanid = SplitLink(GetItemLink(data.bagId,data.slotIndex),3)
    		if id == scanid then return data.bagId, data.slotIndex end
    	end
    end

    function self.SetTraits(traits)
        trait = traits
    end

    local function PutReagents()
        table.insert(result,{plant,{found[trait[1]],found[trait[2]],found[trait[3]]}})
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
    	local bad, cur, acur, val, aval = {}
    	found = {}
    	for _,x in pairs(plant) do
    		for a = 2,5 do
    			cur = reagent[x][a]
    			acur = GetAntiTrait(cur)
    			for _,y in pairs(trait) do
    				val = found[cur] or 0
    				aval = found[acur] or 0
    				if cur == y then found[cur] = val + 1 end
    				found[acur] = aval - 1
    			end
    			val = bad[cur] or 0
    			aval = bad[acur] or 0
    			if IsBad(cur) then bad[cur] = val + 1
    			else bad[acur] = aval - 1 end
    		end
    	end
    	if self.noBad then for _,y in pairs(bad) do if y > 1 then found = {}; return end end end
    end

    function self.GetReagentCombination()
    	local size, ok, t = #reagent
        for x = 1,size do
            for y = x+1, size do
                ok = {false,false,false}
                plant = {x,y}
                GetTraits()
                for i = 1,3 do
                    t = trait[i]
                    if t then if found[t] and found[t] > 1 then ok[i] = true end
                    else ok[i] = true end
                end
                if ok[1] and ok[2] and ok[3] then PutReagents() end
                if self.three then
                    for z = y+1, size do
                        ok = {false,false,false}
                        plant = {x,y,z}
        	            GetTraits()
                        for i = 1,3 do
                            t = trait[i]
                            if t then if found[t] and found[t] > 1 then ok[i] = true end
                            else ok[i] = true end
                        end
                        if ok[1] and ok[2] and ok[3] then PutReagents() end
                    end
                end
            end
        end
        for nr,x in pairs(result) do
            print(nr..': '..x[1][1]..' ('..x[2][1]..'), '..x[1][2]..' ('..x[2][2]..'), '..(x[1][3] or '-')..' ('..(x[2][3] or '-')..')')
        end
    end
    return self
end

flask = CS.FLASK()
flask.SetTraits({1,3,5})
flask.GetReagentCombination()
