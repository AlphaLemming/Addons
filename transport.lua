FLASK = {}
FLASK.__index = FLASK
function FLASK:new()
	local z = {}
	setmetatable(z,FLASK)
	z.noBad = true
	z.three = true
	z.trait = {}
	z.plant = {}
	z.result = {}
	z.found = {}
	z.solvent = {883,1187,4570,23265,23266,23267,23268,64500,64501}
	z.reagent = {
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
	z.path = 'esoui/art/icons/alchemy/crafting_alchemy_trait_'
	z.icon = {
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
	return z
end
function FLASK:setTraits(traits)
    self.trait = traits
end
function FLASK:isBad(trait)
	if trait%2 == 0 and trait < 24 then return true end
	return false
end
function FLASK:getAntiTrait(trait)
	if trait%2 == 0 then return trait - 1 end
	return trait + 1
end
function FLASK:checkTraits()
	local bad, cur, acur, val, aval = {}
	self.found = {}
	for _,x in pairs(self.plant) do
		for a = 2,5 do
			cur = self.reagent[x][a]
			acur = self:getAntiTrait(cur)
			for _,y in pairs(self.trait) do
				val = self.found[cur] or 0
				aval = self.found[acur] or 0
				if cur == y then self.found[cur] = val + 1 end
				self.found[acur] = aval - 1
			end
			val = bad[cur] or 0
			aval = bad[acur] or 0
			if self:isBad(cur) then bad[cur] = val + 1
			else bad[acur] = aval - 1 end
		end
	end
	if self.noBad then for _,y in pairs(bad) do if y > 1 then self.found = {}; return end end end
end
function FLASK:getReagents()
	local size, ok = #self.reagent
    for x = 1,size do
        for y = x+1, size do
            ok = {false,false,false}
            self.plant = {x,y}
            self:checkTraits()
            for i = 1,3 do
                local t = self.trait[i]
                if t then if self.found[t] and self.found[t] > 1 then ok[i] = true end
                else ok[i] = true end
            end
            if ok[1] and ok[2] and ok[3] then table.insert(self.result,self.plant) end
            if self.three then
                for z = y+1, size do
                    ok = {false,false,false}
                    self.plant = {x,y,z}
    	            self:checkTraits()
                    for i = 1,3 do
                        local t = self.trait[i]
                        if t then if self.found[t] and self.found[t] > 1 then ok[i] = true end
                        else ok[i] = true end
                    end
                    if ok[1] and ok[2] and ok[3] then table.insert(self.result,self.plant) end
                end
            end
        end
    end
    for nr,x in pairs(self.result) do print(nr..': '..x[1]..','..x[2]..','..(x[3] or '-')) end
end

flask = FLASK:new()
flask:setTraits({1,3,5})
flask:getReagents()
