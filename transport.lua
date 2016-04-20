<Button name="$(parent)24Hour" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold" clickSound="Click">
	<Anchor point="12" relativePoint="6" relativeTo="$(parent)Research6" offsetX="-5" />
	<Dimensions x="72" y="41" />
	<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
	<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
</Button>
<Button name="$(parent)12Hour" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold" clickSound="Click">
	<Anchor point="8" relativePoint="2" relativeTo="$(parent)24Hour" offsetX="-5" />
	<Dimensions x="72" y="41" />
	<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
	<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
</Button>
<Button name="$(parent)Player" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold" clickSound="Click">
	<Anchor point="8" relativePoint="2" relativeTo="$(parent)12Hour" offsetX="-5" />
	<Dimensions x="205" y="41" />
	<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
	<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
</Button>
<Button name="$(parent)Menu" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold" clickSound="Click">
	<Anchor point="8" relativePoint="2" relativeTo="$(parent)Player" offsetX="-5" />
	<Dimensions x="153" y="31" />
	<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
	<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
</Button>
<Button name="$(parent)Sign1" verticalAlignment="1" horizontalAlignment="2" font="CS4Font">
	<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="35" />
	<Dimensions x="153" y="31" />
	<Textures normal="CraftStore4/grey.dds" />
	<FontColors normalColor="999999" />
</Button>
<Button name="$(parent)Sign2" verticalAlignment="1" horizontalAlignment="2" font="CS4Font">
	<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="35" />
	<Dimensions x="153" y="301" />
	<Textures normal="CraftStore4/grey.dds" />
	<FontColors normalColor="999999" />
</Button>
<Button name="$(parent)Sign3" verticalAlignment="1" horizontalAlignment="2" font="CS4Font">
	<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="35" />
	<Dimensions x="153" y="337" />
	<Textures normal="CraftStore4/grey.dds" />
	<FontColors normalColor="999999" />
</Button>
<Button name="$(parent)Sign4" verticalAlignment="1" horizontalAlignment="2" font="CS4Font">
	<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="35" />
	<Dimensions x="153" y="603" />
	<Textures normal="CraftStore4/grey.dds" />
	<FontColors normalColor="999999" />
</Button>

CS4_PanelMenu:SetText('t16:16:CraftStore4/menu.dds|t '..LANG:Get('menu'))
CS4_PanelSign1:SetText(GetString()..'|t5:5:x.dds|t')
CS4_PanelSign2:SetText(GetString()..'|t5:5:x.dds|t')
CS4_PanelSign3:SetText(GetString()..'|t5:5:x.dds|t')
CS4_PanelSign4:SetText(GetString()..'|t5:5:x.dds|t')

