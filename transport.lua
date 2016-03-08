local FLASK = {
	reagent = {},
	noBad = false,
	solvent = {883,1187,4570,23265,23266,23267,23268,64500,64501},
	reagentTrait = {
		{30165,2,14,12,23},
		{30158,9,3,18,13},
		{30155,6,8,1,22},
		{30152,18,2,9,4},
		{30162,7,5,16,11},
		{30148,4,10,1,23},
		{30149,16,2,7,6},
		{30161,3,9,2,24},
		{30160,17,1,10,3},
		{30154,10,4,17,12},
		{30157,5,7,2,21},
		{30151,2,4,6,20},
		{30164,1,3,5,19},
		{30159,11,22,24,19},
		{30163,15,1,8,5},
		{30153,13,21,23,19},
		{30156,8,6,15,12},
		{30166,1,13,11,20}
	},
	solventSelection = 1,
	traitSelection = {1},
	traitIcon = {
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
}

function IsBad(trait)
	if not trait return false end
	if trait%2 == 0 and trait < 24 then return true end
	return false
end
function GetAntiTrait(trait)
	if not trait return false end
	if trait%2 == 0 then return trait - 1 end
	return trait + 1
end
function CheckTraits(reagent,trait)
    local found = {0,0,0}
	for a = 2,5 do
	    for _,x in pairs(reagent) do
	        for nr,y in pairs(trait) do
	            if FLASK.reagentTrait[x][a] == y then found[nr] = found[nr] + 1 end
   	            if GetAntiTrait(FLASK.reagentTrait[x][a]) == y then found[nr] = found[nr] - 1 end
            end
	    end
    end
    return found
end

function FindReagent(traits)
	if not traits[1] then return end
	local result, found = {}, {}
    for x = 1,#FLASK.reagentTrait do
        for y = x+1,#FLASK.reagentTrait do
            for z = y+1,#FLASK.reagentTrait do
	            found = CheckTraits({x,y,z},{traits[1],traits[2],traits[3]})
	            if traits[1] and found[1] > 1 then
	                if traits[2] and found[2] > 1 then
    	                if traits[3] then
    	                    if found[3] > 1 then table.insert(result,{x,y,z}) end
    	                else
    	                    table.insert(result,{x,y,0})
    	                end
    	            end    
    	        end
            end
        end
    end
    for _,x in pairs(result) do print(x[1]..','..x[2]..','..x[3]) end
end

FindReagent({1,3,5})
