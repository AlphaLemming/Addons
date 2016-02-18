				<Backdrop name="$(parent)OptionPanel" centerColor="598527" edgeColor="00000000" hidden="true">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-10" offsetY="35"/><Edge edgeSize="1"/>
					<Controls></Controls>
				</Backdrop>
				
				<Control name="$(parent)EditPanel" hidden="true"><Dimensions x="307" y="350"/>
					<Controls>
						<Button name="$(parent)GearConnector" clickSound="Click" horizontalAlignment="1" verticalAlignment="1" font="AGFontBold">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)"/><Dimensions x="48" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
						</Button>
						<Button name="$(parent)GearLock" clickSound="Click">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="50"/><Dimensions x="47" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
							<Controls><Texture name="$(parent)Tex" textureFile="AlphaGearX2/unlocked.dds"><Anchor point="128"/><Dimensions x="32" y="32"/></Texture></Controls>
						</Button>
						<Control name="$(parent)Gear1Box"><Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="99"/><Dimensions x="208" y="40"/></Control>
						<Control name="$(parent)Gear2Box"><Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="99" offsetY="42"/><Dimensions x="208" y="40"/></Control>
						
						<Button name="$(parent)Bar1Name" clickSound="Click" horizontalAlignment="0" verticalAlignment="1" font="AGFont">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetY="92"/><Dimensions x="307" y="40"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
						</Button>
						<Button name="$(parent)Bar1Connector" clickSound="Click" horizontalAlignment="1" verticalAlignment="1" font="AGFontBold">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetY="134"/><Dimensions x="48" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
						</Button>
						<Button name="$(parent)Bar1Icon" clickSound="Click">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="50" offsetY="134"/><Dimensions x="89" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
							<Controls><Texture name="$(parent)Tex"><Anchor point="128" relativeTo="$(parent)"/><Dimensions x="64" y="64"/></Texture></Controls>
						</Button>
						<Control name="$(parent)Weap1Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="141" offsetY="134"/><Dimensions x="40" y="82"/></Control>
						<Control name="$(parent)Skill11Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="182" offsetY="134"/><Dimensions x="124" y="40"/></Control>
						<Control name="$(parent)Skill12Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="182" offsetY="176"/><Dimensions x="124" y="40"/></Control>
						
						<Button name="$(parent)Bar2Name" clickSound="Click" horizontalAlignment="0" verticalAlignment="1" font="AGFont">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetY="226"/><Dimensions x="307" y="40"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
						</Button>
						<Button name="$(parent)Bar2Connector" clickSound="Click" horizontalAlignment="1" verticalAlignment="1" font="AGFontBold">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetY="268"/><Dimensions x="48" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
						</Button>
						<Button name="$(parent)Bar2Icon" clickSound="Click">
							<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="50" offsetY="268"/><Dimensions x="89" y="82"/>
							<Textures normal="AlphaGearX2/grey.dds" mouseOver="AlphaGearX2/light.dds"/>
							<OnClicked></OnClicked>
							<Controls><Texture name="$(parent)Tex"><Anchor point="128" relativeTo="$(parent)"/><Dimensions x="64" y="64"/></Texture></Controls>
						</Button>
						<Control name="$(parent)Weap2Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="141" offsetY="268"/><Dimensions x="40" y="82"/></Control>
						<Control name="$(parent)Skill21Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="183" offsetY="268"/><Dimensions x="124" y="40"/></Control>
						<Control name="$(parent)Skill22Box"><Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="183" offsetY="310"/><Dimensions x="124" y="40"/></Control>
					</Controls>
				</Control>

function AG4.DrawSet(nr)
	if WM:GetControlByName('AG_SetSelector_'..nr) then return end
	local p,l,s = WM:GetControlByName('AG_SetSelector_'..(nr-1)) or false
	s = WM:CreateControl('AG_SetSelector_'..nr, AG_PanelSetPanelScrollChild, CT_BUTTON)
	if p then s:SetAnchor(2,p,4,0,5) else s:SetAnchor(3,nil,3,0,0) end
	s:SetDimensions(311,76)
	s:SetClickSound('Click')
	s:EnableMouseButton(2,true)
	s:SetNormalTexture('AlphaGearX2/grey.dds')
	s:SetMouseOverTexture('AlphaGearX2/light.dds')
	s:SetHandler('OnMouseEnter',function(self) AG4.Tooltip(self,true) end)
	s:SetHandler('OnMouseExit',function(self) AG4.Tooltip(self,false) end)
	s:SetHandler('OnMouseDown',function(self,button)
		if button == 2 then
			SELECT = nr
			AG_PanelEditPanel:ClearAnchors()
			AG_PanelEditPanel:SetAnchor(6,self,6,-2,-2)
			AG_PanelEditPanel:ToggleHidden()
			if not AG_PanelEditPanel:Ishidden() then self:SetHeight(426) else self:SetHeight(76) end
		elseif button == 1 then AG4.LoadSet(nr) end
	end)
	l = WM:CreateControl('AG_SetSelector_'..nr..'_Label', s, CT_LABEL)
	l:SetAnchor(3,s,3,0,0)
	l:SetDrawTier(1)
	l:SetDimensions(44,44)
	l:SetHorizontalAlignment(1)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFontBold')
	l:SetColor(1,1,1,0.8)
	l:SetText(nr)
	l = WM:CreateControl('AG_SetSelector_'..nr..'_KeyBind', s, CT_LABEL)
	l:SetAnchor(9,s,9,-15,0)
	l:SetDrawTier(1)
	l:SetDimensions(235,44)
	l:SetHorizontalAlignment(2)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.5)
	l = WM:CreateControl('AG_SetButton_'..nr..'_Box', s, CT_LABEL)
	l:SetAnchor(3,s,3,2,44)
	l:SetDrawTier(1)
	l:SetDimensions(307,30)
	l:SetHorizontalAlignment(0)
	l:SetVerticalAlignment(1)
	l:SetFont('AGFont')
	l:SetColor(1,1,1,0.8)
	s = WM:CreateControl('AG_SetButton_'..nr..'_BoxBg', l, CT_BACKDROP)
	s:SetAnchorFill()
	s:SetCenterColor(0,0,0,0.2)
	s:SetEdgeColor(0,0,0,0)
	s:SetEdgeTexture('',1,1,2)
end

function AG4.GetSetIcon(nr,bar)
	local icon = {
		[WEAPONTYPE_NONE] = false,
		[WEAPONTYPE_DAGGER] = 'onehand',
		[WEAPONTYPE_HAMMER] = 'onehand',
		[WEAPONTYPE_AXE] = 'onehand',
		[WEAPONTYPE_SWORD] = 'onehand',
		[WEAPONTYPE_TWO_HANDED_HAMMER] = 'twohand',
		[WEAPONTYPE_TWO_HANDED_AXE] = 'twohand',
		[WEAPONTYPE_TWO_HANDED_SWORD] = 'twohand',
		[WEAPONTYPE_FIRE_STAFF] = 'fire',
		[WEAPONTYPE_FROST_STAFF] = 'frost',
		[WEAPONTYPE_LIGHTNING_STAFF] = 'shock',
		[WEAPONTYPE_HEALING_STAFF] = 'heal',
		[WEAPONTYPE_BOW] = 'bow',
		[WEAPONTYPE_SHIELD] = 'shield'
	}
	if bar == 1 then return icon[GetItemLinkWeaponType(AG4.setdata[nr].Set.Gear[1].link)] or false
	else return icon[GetItemLinkWeaponType(AG4.setdata[nr].Set.Gear[3].link)] or false end
end

function AG4.DrawOptions(set)
	local val, tex = {[true]='checked',[false]='unchecked'}, '|t16:16:esoui/art/buttons/checkbox_<<1>>.dds|t  '
	if not set then
		local w,h,c,swatch = 400, #L.Options*25+20
		for x,opt in pairs(L.Options) do
			c = WM:CreateControl('AG_Option_'..x, AG_PanelOptionPanel, CT_BUTTON)
			c:SetAnchor(3,AG_PanelOptionPanel,3,10,10+(x-1)*25)
			c:SetDimensions(w-20,25)
			if opt == '-' then
				c:SetNormalTexture('AlphaGearX2/row.dds')
			else
				c:SetNormalFontColor(1,1,1,1)
				c:SetMouseOverFontColor(1,1,0,1)
				c:SetFont('ZoFontGame')
				c:SetHorizontalAlignment(0)
				c:SetVerticalAlignment(1)
				c:SetClickSound('Click')
				c:SetHandler('OnClick',function(self) AG4.DrawOptions(x) end)
				c:SetText(ZOSF(tex,val[AG4.account.option[set]])..opt)
			end
		end
		AG_PanelOptionPanel:SetDimensions(w,h)
	else
		AG4.account.option[set] = not AG4.account.option[set]
		WM:GetControlByName('AG_Option_'..set):SetText(ZOSF(tex,val[AG4.account.option[set]])..L.Options[set])
		AG4.SetOptions()
	end
end
