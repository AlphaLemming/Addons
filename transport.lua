{77583,18,29,15,27} -- Beetle Scuttle
{77585,1,25,12,27} -- Butterfly Wing
{77587,6,26,30,27} -- Fleshfly Larva
{77591,17,29,15,28} -- Mudcrab Chitin
{77590,2,2629,23} -- Nightshade
{77589,4,30,21,25} -- Scrib Jelly
{77584,22,25,23,28} -- Spider Egg
{77581,16,12,24,27} -- Torchbug Thorax
'crafting_poison_trait_hot','crafting_poison_trait_dot',
'crafting_poison_trait_increasehealing','crafting_poison_trait_decreasehealing',
'crafting_poison_trait_protection','crafting_poison_trait_damage'

'Leben wiederherstellen',
'Lebensverwüstung',
'Magicka wiederherstellen',
'Magickaverwüstung',
'Ausdauer wiederherstellen',
'Ausdauerverwüstung',
'Erhöht Waffenkraft',
'Verringert Waffenkraft',
'Erhöht Magiekraft',
'Verringert Magiekraft',
'Kritische Waffentreffer',
'Verringert kritische Waffentreffer',
'Kritische Zaubertreffer',
'Verringert kritische Zaubertreffer',
'Erhöht Rüstung',
'Verringert Rüstung',
'Erhöht Magieresistenz',
'Verringert Magieresistenz',
'Sicherer Stand',
'Betäubung',
'Tempo',
'Reduziert Tempo',
'Unsichtbarkeit',
'Detektion',
'Beständige Heilung',
'Schleichende Lebensverwüstung',
'Vitalität',
'Verwundbarkeit',
'Schutz',
'Schänden'
}

function self:CreateButton(x,y,parent,name,anchor,text,tooltip,buttons,func,data,texture)
	local c = WM:CreateControl('$(parent)'..name, parent, CT_BUTTON)
	if anchor then c:SetAnchor(unpack(anchor)) else c:SetAnchor(3,parent,3,0,0) end
	if x and y then c:SetDimensions(x,y) else c:SetDimensions(40,40) end
	c:SetNormalTexture('CraftStore4/grey.dds')
	c:SetMouseOverTexture('CraftStore4/over.dds')
	if func then
		c:SetClickSound('Click')
		if buttons > 1 then
			c:SetHandler('OnMouseDown',function(...) func end)
			c:EnableMouseButton(2,true)
			c:EnableMouseButton(3,true)
		else c:SetHandler('OnClicked',function(...) func end) end
	end
	if text then
		c:SetText(text[1])
		c:SetVerticalAlignment(1)
		if text[2] then c:SetHorizontalAlignment(text[2]) else c:SetHorizontalAlignment(1) end
		if text[3] then c:SetNormalFontColor(unpack(text[3])) else c:SetNormalFontColor(1,1,1,1) end
		if text[4] then c:SetMouseOverFontColor(unpack(text[4])) else c:SetMouseOverFontColor(1,0.66,0.2,1) end
		if text[5] then c:SetNormalFont(text[5]) else c:SetNormalFont('CS4Font') end
	end
	if tooltip then
		c:SetHandler('OnMouseEnter',function() TT:ShowTooltip() end)
		c:SetHandler('OnMouseExit',function() TT:HideTooltip() end)
	end
	if data then c.cs_data = data end
	if texture then
		local t = WM:CreateControl('$(parent)Texture', c, CT_TEXTURE)
		t:SetTexture(texture)
		t:SetColor(1,1,1,1)
		t:SetAnchor(CENTER)
		t:SetDimensions(x-6,y-6)
	end
end

for nr,reagent in pairs(CraftStore.traiticons) do
	PANEL:CreateButton(
		40, 40, CS4_Flask, 'Traitbutton',
		{3,CS4_Flask,3,0,(nr-1)*40},
		false, true, 1,
		function(self) end,
		{ anchor = {1,4,self,0,2}, info = 'Reagent'..nr },
		'eso/art/'..reagent..'.dds'
	)
end

