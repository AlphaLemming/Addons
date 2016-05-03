function self:NilZero(val)
	if not val or val == 0 then return nil end
	return val
end

	EM:RegisterForEvent('CraftStore_PlayerLoad',EVENT_PLAYER_ACTIVATED,function()
		if CraftStore.init then return end
	end)


			bag = {nil,'Bank',nil,nil,'Handwerkstasche',nil}


		local function HandleItem(_,bag,slot,new)
			if bag ~= BAG_VIRTUAL and bag ~= BAG_BACKPACK and bag ~= BAG_BANK then return end
			local stock = CraftStore.account.stock
			local link = GetItemLink(bag,slot) or bagCache[bag][slot].link
			local uid = Id64ToString(GetItemUniqueId(bag,slot)) or bagCache[bag][slot].uid
			local id = TOOLS:SplitLink(link,3) or bagCache[bag][slot].id
			local a1, a2, a3 = GetItemLinkStacks(link)
			if new then bagCache[bag][slot] = { link = link, uid = uid, id = id }
			else bagCache[bag][slot] = nil end
			if not stock[id] then stock[id] = {} end
			stock[id].link = link
			stock[id][SELF] = TOOLS:NilZero(a1)
			stock[id]['aa'] = TOOLS:NilZero(a2)
			stock[id]['ab'] = TOOLS:NilZero(a3)
			if TOOLS:TabLen(stock[id]) == 1 then stock[id] = nil end
			local craft,line,trait = TRAIT:FindTrait(link)
			if craft and line and trait and uid then
				local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false, id = 0 }
				local owner = LANG:Get('bag')[bag] or SELF
				if uid == store.id then
					if not GetItemInstanceId(bag,slot) then store[craft..'&'..line..'&'..trait] = nil
					else store[craft..'&'..line..'&'..trait].owner = owner end
				elseif TOOLS:CompareItem(link, store.link) and not GetItemLinkSetInfo(link) then
					store[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid }
				end
				SetIcon(craft,line,trait)
			end
		end
		
		for _,bag in pairs(bags) do
			bagCache[bag] = {}
			for slot = 0, GetBagSize(bag)-1 do
				local link, uid, id = GetItemLink(bag,slot), Id64ToString(GetItemUniqueId(bag,slot))
				id = TOOLS:SplitLink(link,3)
				bagCache[bag][slot] = { link = link, uid = uid, id = id }
				local a1, a2, a3 = GetItemLinkStacks(link)
				if not stock[id] then stock[id] = {} end
				stock[id].link = link
				stock[id][SELF] = TOOLS:NilZero(a1)
				stock[id]['aa'] = TOOLS:NilZero(a2)
				stock[id]['ab'] = TOOLS:NilZero(a3)
				if TOOLS:TabLen(stock[id]) == 1 then stock[id] = nil end
				local craft,line,trait = TRAIT:FindTrait(link)
				if craft and line and trait and uid then
					local store = CraftStore.account.stored[craft..'&'..line..'&'..trait] or { link = false, id = 0 }
					local owner = LANG:Get('bag')[bag] or SELF
					if uid == store.id then
						if not GetItemInstanceId(bag,slot) then store[craft..'&'..line..'&'..trait] = nil
						else store[craft..'&'..line..'&'..trait].owner = owner end
					elseif TOOLS:CompareItem(link, store.link) and not GetItemLinkSetInfo(link) then
						store[craft..'&'..line..'&'..trait] = { link = link, owner = owner, id = uid }
					end
				end
			end
		end

		EM:RegisterForEvent('CraftStore_HandleItem', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, HandleItem)
		EM:RegisterForEvent('CraftStore_SkillChanged', EVENT_SKILL_POINTS_CHANGED, SetPlayerSkill)
