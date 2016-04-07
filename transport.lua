function CraftStore:TOOLTIP()
	self = {}
	local cs_trait = CraftStore:TRAIT()
	local cs_player = CraftStore:PLAYER()

	local function FadeIn(c)
		local a = ANIMATION_MANAGER:CreateTimeline()
		local fade = a:InsertAnimation(ANIMATION_ALPHA,c)
		c:SetAlpha(0)
		c:SetHidden(false)
		fade:SetAlphaValues(0,1)
		fade:SetDuration(150)
		a:PlayFromStart()
	end

	local function FadeOut(c)
		local a = ANIMATION_MANAGER:CreateTimeline()
		local fade = a:InsertAnimation(ANIMATION_ALPHA,c)
		fade:SetAlphaValues(1,0)
		fade:SetDuration(100)
		a:PlayFromStart()
		zo_callLater(function() c:SetHidden(true) end, 110)
	end
	
	local function Insert(c,data)
		c:AddVerticalPadding(5)
		c:AddLine(data,'CS4Font')
	end

	function self:ShowTooltip(c)
		if c.cs_data then
			if c.cs_data.link then
				c.tt = ItemTooltip
				InitializeTooltip(c.tt,anchor[1],anchor[2],anchor[4],anchor[5],anchor[3])
				c.tt:SetLink(c.cs_data.link)
				ZO_ItemTooltip_ClearCondition(c.tt)
				ZO_ItemTooltip_ClearCharges(c.tt)
			elseif c.cs_data.info then
				c.tt = InformationTooltip
				InitializeTooltip(c.tt,anchor[1],anchor[2],anchor[4],anchor[5],anchor[3])
				SetTooltipText(c.tt,c.cs_data.info)
			end
			if c.cs_data.line then for _,data in pairs(c.cs_data.line) Insert(c,data) end end
			c.tt:SetHidden(false)
		end
	end

	function self:HideTooltip(c)
		c.tt:SetHidden(true)
		ClearTooltip(c.tt)
		c.tt = nil
	end

	local function IsItemNeeded(craft,line,trait,id,link)
		if not craft or not line or not trait then return end
		local isSet = GetItemLinkSetInfo(link)
		local isSelf, needy, storedId = false, {}, CraftStore.account.stored[craft][line][trait].id or 0
		if not isSet and (storedId == id or (not id and storedId == 0)) then
			for _,char in pairs(cs_player:GetCharacters()) do
				if CraftStore.account[char].research[craft][line].active and not CraftStore.account[char].research[craft][line][trait] then
					if cs_player:GetSelf(char) then isSelf = true end
					table.insert(needy,'|t24:24:CraftStore4/dds/cross.dds|t |cFF1010'..char..'|r')
				end
			end
		end
		return table.concat(needy,'\n'), isSelf
	end

	local function TooltipShow(c,link,id)
		if not link then return end
		local it, needy = GetItemLinkItemType(link)
		-- if it == ITEMTYPE_RACIAL_STYLE_MOTIF then need = CS.IsStyleNeeded(link)
		-- elseif it == ITEMTYPE_RECIPE then need = CS.IsRecipeNeeded(link)
		-- elseif it == ITEMTYPE_LURE then need = CS.IsBait(link)
		-- elseif it == ITEMTYPE_ENCHANTING_RUNE_POTENCY then need = CS.IsPotency(link)
		local craft, line, trait = cs_trait:FindTrait(link)
		if craft and line and trait then
			-- if CS.account.option[9] then c:AddLine('\n|cC5C29E'..ZOSF('<<ZC:1>>',GetString('SI_ITEMSTYLE',GetItemLinkItemStyle(link)))..'|r','ZoFontGameSmall')end
			if craft and line and trait then needy = IsItemNeeded(craft,line,trait,id,link) end
		end
		if needy ~= '' then Insert(c,needy) end
	end

	function self:TooltipHandler()
		local tt=ItemTooltip.SetBagItem
		ItemTooltip.SetBagItem=function(c,bag,slot,...)
			tt(c,bag,slot,...)
			TooltipShow(c,GetItemLink(bag,slot),Id64ToString(GetItemUniqueId(bag,slot)))
		end
		local tt=ItemTooltip.SetLootItem
		ItemTooltip.SetLootItem=function(c,id,...)
			tt(c,id,...)
			TooltipShow(c,GetLootItemLink(id))
		end
		local ResultTooltip=ZO_SmithingTopLevelCreationPanelResultTooltip
		local tt=ResultTooltip.SetPendingSmithingItem
		ResultTooltip.SetPendingSmithingItem=function(c,pid,mid,mq,sid,tid)
			tt(c,pid,mid,mq,sid,tid)
			TooltipShow(c,GetSmithingPatternResultLink(pid,mid,mq,sid,tid))
		end	
		local tt=PopupTooltip.SetLink
		PopupTooltip.SetLink=function(c,link,...)
			tt(c,link,...)
			TooltipShow(c,link)
		end
		local tt=ItemTooltip.SetAttachedMailItem
		ItemTooltip.SetAttachedMailItem=function(c,oid,aid,...)
			tt(c,oid,aid,...)
			TooltipShow(c,GetAttachedItemLink(oid,aid))
		end
		local tt=ItemTooltip.SetBuybackItem
		ItemTooltip.SetBuybackItem=function(c,id,...)
			tt(c,id,...)
			TooltipShow(c,GetBuybackItemLink(id))
		end
		local tt=ItemTooltip.SetTradingHouseItem
		ItemTooltip.SetTradingHouseItem=function(c,id,...)
			tt(c,id,...)
			TooltipShow(c,GetTradingHouseSearchResultItemLink(id))
		end
		local tt=ItemTooltip.SetTradingHouseListing
		ItemTooltip.SetTradingHouseListing=function(c,id,...)
			tt(c,id,...)
			TooltipShow(c,GetTradingHouseListingItemLink(id))
		end
		local tt=ItemTooltip.SetTradeItem
		ItemTooltip.SetTradeItem=function(c,_,slot,...)
			tt(c,_,slot,...)
			TooltipShow(c,GetTradeItemLink(slot))
		end
		local tt=ItemTooltip.SetQuestReward
		ItemTooltip.SetQuestReward=function(c,id,...)
			tt(c,id,...)
			TooltipShow(c,GetQuestRewardItemLink(id))
		end
	end

	return self
end


	local WM = WINDOW_MANAGER
	local cs_tt = CraftStore:TOOLTIP()
	local _,_,maxtrait = GetSmithingResearchLineInfo(CRAFTING_TYPE_BLACKSMITHING,1)

	local function ToChat(text) StartChatInput(CHAT_SYSTEM.textEntry:GetText()..text) end

	local function SetResearch(craft,line,trait)
	end

	local function PostTrait(craft,line,trait)
	end

	local function DrawColumn(craft,line,parent)
		local name, icon = GetSmithingResearchLineInfo(craft,line)
		local craftname = GetSkillLineInfo(GetCraftingSkillLineIndices(craft))
		local c = WM:CreateControl('$(parent)Line'..line, parent, CT_BUTTON)
		c:SetAnchor(3,parent,3,(line-1)*26,0)
		c:SetDimensions(29,maxtrait*26+63)
		c:SetNormalTexture('CraftStore4/dds/grey.dds')
		c:SetMouseOverTexture('CraftStore4/dds/over.dds')
		c.cs_data = { info = craftname, anchor = {c,1,4,0,3} }
		local x = WM:CreateControl('$(parent)Texture', c, CT_TEXTURE)
		x:SetAnchor(1,c,1,0,2)
		x:SetDimensions(27,27)
		x:SetTexture(icon)
		for trait = 1, maxtrait do
			local t = WM:CreateControl('$(parent)Trait'..trait, c, CT_BUTTON)
			t:SetAnchor(3,c,3,2,33+(trait-1)*26)
			t:SetDimensions(25,25)
			t:SetMouseOverTexture('CraftStore4/dds/over.dds')
			t:SetClickSound('Click')
			t:SetEnableMouseButton(2,true)
			t:SetHandler('OnMouseEnter', function(self) cs_tt:ShowTooltip(self) end)
			t:SetHandler('OnMouseExit', function(self) cs_tt:HideTooltip(self) end)
			t:SetHandler('OnMouseDown', function(self,button) if button == 1 then SetResearch(craft,line,trait) else PostTrait(craft,line,trait) end end)
		end
		local l = WM:CreateControl('$(parent)Count', c, CT_BUTTON)
		l:SetAnchor(4,c,4,0,-2)
		l:SetDimensions(25,25)
		l:SetHorizontalAlign(1)
		l:SetVerticalAlign(1)
		l:SetFont('CS4Font')
		l:SetNormalFontColor(1,1,1,1)
		l:SetNormalTexture('CraftStore4/dds/dark.dds')
		local b = WM:CreateControl('$(parent)Blend', c, CT_BUTTON)
		b:SetAnchor(3,c,3,0,32)
		b:SetDimensions(29,maxtrait*26+31)
		b:SetNormalTexture('CraftStore4/dds/grey.dds')
		b:SetMouseOverTexture('CraftStore4/dds/over.dds')
		b:SetHidden(true)
		local x = WM:CreateControl('$(parent)Texture', b, CT_TEXTURE)
		x:SetAnchor(128,b,128,0,0)
		x:SetDimensions(27,27)
		x:SetTexture('CraftStore4/dds/disabled.dds')
	end

	local function DrawTraitRow(line,trait,nr,y)
		local c = WM:CreateControl('CS4_TraitRow'..trait, CS4_Panel, CT_BUTTON)
		local _,desc = GetSmithingResearchLineTraitInfo(CRAFTING_TYPE_BLACKSMITHING,line,trait)
		local _,name,icon = GetSmithingTraitItemInfo(trait + 1)
		c:SetAnchor(3,CS4_Panel,6,10,y+(nr-1)*26)
		c:SetDimensions(153,25)
		c:SetText(zo_strformat('<<C:1>>',name)..' |t25:25:'..icon..'|t ')
		c:SetHorizontalAlign(2)
		c:SetVerticalAlign(1)
		c:SetFont('CS4Font')
		c:SetNormalFontColor(1,1,1,1)
		c:SetMouseOverFontColor(1,0.66,0.2,1)
		c:SetNormalTexture('CraftStore4/dds/grey.dds')
		c:SetHandler('OnMouseEnter', function(self) cs_tt:ShowTooltip(self) end)
		c:SetHandler('OnMouseExit', function(self) cs_tt:HideTooltip(self) end)
		c.cs_data = { info = desc, anchor = {c,2,8,3,0} }
	end

	function self:DrawMatrix()
		local craft = CRAFTING_TYPE_CLOTHIER
		local cs_trait = CraftStore:TRAIT()

		for trait,nr in pairs(cs_trait:GetArmorTraits()) do DrawTraitRow(8,trait,nr,69) end
		for trait,nr in pairs(cs_trait:GetWeaponTraits()) do DrawTraitRow(1,trait,nr,369) end

		local c1 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
		c1:SetAnchor(3,CS4_Armor_TraitRow1,9,1,-32)
		c1:SetResizeToFitDescendents(true)
		for line = 1, 7 do DrawColumn(craft,line,c1) end

		local c2 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
		c2:SetAnchor(3,c1,9,5,0)
		c2:SetResizeToFitDescendents(true)
		for line = 8, 14 do DrawColumn(craft,line,c2) end
		
		craft = CRAFTING_TYPE_BLACKSMITHING
		
		local c3 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
		c3:SetAnchor(3,c2,9,5,0)
		c3:SetResizeToFitDescendents(true)
		for line = 8, 14 do DrawColumn(craft,line,c3) end

		local c4 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
		c4:SetAnchor(3,CS4_Weapon_TraitRow1,9,5,-32)
		c4:SetResizeToFitDescendents(true)
		for line = 1, 7 do DrawColumn(craft,line,c4) end
		
		craft = CRAFTING_TYPE_WOODWORKING
		
		local c5 = CreateControl('CS4_Block1_Craft'..craft, CS4_Panel, CT_CONTROL)
		c5:SetAnchor(3,c3,9,5,0)
		c5:SetResizeToFitDescendents(true)
		DrawColumn(craft,6,c5) end

		local c6 = CreateControl('CS4_Block2_Craft'..craft, CS4_Panel, CT_CONTROL)
		c6:SetAnchor(3,c4,9,5,0)
		c6:SetResizeToFitDescendents(true)
		for line = 1, 5 do DrawColumn(craft,line,c6) end
	end
