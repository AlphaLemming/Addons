<GuiXml>
    <Controls>
        <TopLevelControl hidden="true" name="CS4_Rune">
            <Anchor point="8" relativePoint="8" relativeTo="GuiRoot" />
            <Dimensions x="529" y="800" />
            <Controls>
 				<Backdrop name="$(parent)BG" centerColor="181818" edgeColor="00000000">
					<AnchorFill/>
					<Edge edgeSize="1" />
				</Backdrop>
				<Label name="$(parent)Headline" font="CS4Font" color="FFAA33" text="CraftStoreRune">
					<Anchor point="2" relativePoint="2" relativeTo="$(parent)" offsetX="10" offsetY="5" />
				</Label>
                <Backdrop name="$(parent)SearchAmount" centerColor="282828" edgeColor="00000000">
                    <Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="30" />
                    <Dimensions x="163" y="40" />
                    <Edge edgeSize="1" />
                </Backdrop>
                <Button name="$(parent)LevelButton" clickSound="Click" horizontalAlignment="1" verticalAlignment="1" font="CS4Font">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)SearchAmount" offsetX="1" />
                    <Dimensions x="263" y="40" />
                    <FontColors normalColor="E8DFAF" mouseOverColor="FFAA33" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                </Button>
                <Button hidden="true" name="$(parent)ExtractAll" clickSound="Click" horizontalAlignment="1" verticalAlignment="1" font="CS4Font">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)SearchAmount" offsetX="1" />
                    <Dimensions x="263" y="40" />
                    <FontColors normalColor="E8DFAF" mouseOverColor="FFAA33" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                </Button>
                <Button name="$(parent)CreateButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)LevelButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/tutorial/smithing_tabicon_creation_up.dds">
                            <Dimensions y="36" x="36" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)RefineButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)CreateButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_deconstruction_up.dds">
                            <Dimensions y="36" x="36" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button hidden="true" name="$(parent)LevelMenu" level="1" tier="1">
                    <Anchor point="1" relativePoint="4" relativeTo="$(parent)LevelButton" offsetY="1" />
                    <Dimensions x="263" y="350" />
					<Textures normal="CraftStore4/grey.dds" />
                </Button>
                <Button name="$(parent)ArmorButton" clickSound="Click">
                    <Anchor point="3" relativePoint="6" relativeTo="$(parent)SearchAmount" offsetY="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/icons/enchantment_armor_healthboost.dds">
                            <Dimensions y="28" x="28" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)WeaponButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)ArmorButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/icons/enchantment_weapon_berserking.dds">
                            <Dimensions y="28" x="28" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)JewelryButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)WeaponButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/icons/enchantment_jewelry_increaseweapondamage.dds">
                            <Dimensions y="28" x="28" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)HandmadeButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)JewelryButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/icons/crafting_components_runestones_017.dds">
                            <Dimensions y="28" x="28" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)FavoriteButton" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)HandmadeButton" offsetX="1" />
                    <Dimensions x="40" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="CraftStore/star.dds" color="FFFF00">
                            <Dimensions y="22" x="22" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)Aspect1Button" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)FavoriteButton" offsetX="1" />
                    <Dimensions x="60" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_aspect_up.dds">
                            <Dimensions y="38" x="38" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)Aspect2Button" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)Aspect1Button" offsetX="1" />
                    <Dimensions x="60" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_aspect_up.dds" color="2DC50E">
                            <Dimensions y="38" x="38" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)Aspect3Button" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)Aspect2Button" offsetX="1" />
                    <Dimensions x="60" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_aspect_up.dds" color="3A92FF">
                            <Dimensions y="38" x="38" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)Aspect4Button" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)Aspect3Button" offsetX="1" />
                    <Dimensions x="60" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_aspect_up.dds" color="A02EF7">
                            <Dimensions y="38" x="38" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Button name="$(parent)Aspect5Button" clickSound="Click">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)Aspect4Button" offsetX="1" />
                    <Dimensions x="60" y="40" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
                    <Controls>
                        <Texture name="$(parent)Texture" textureFile="esoui/art/crafting/enchantment_tabicon_aspect_up.dds" color="EECA2A">
                            <Dimensions y="38" x="38" />
                            <Anchor point="128" />
                        </Texture>
                    </Controls>
                </Button>
                <Backdrop name="$(parent)GlyphSection" centerColor="202020" edgeColor="00202020" inherits="ZO_ScrollContainerBase">
                    <Anchor point="3" relativePoint="6" relativeTo="$(parent)ArmorButton" offsetY="1" />
                    <Dimensions x="509" y="660" />
                    <Edge edgeSize="1" />
                    <OnInitialized>ZO_Scroll_Initialize(self)</OnInitialized>
                    <Controls>
                        <Control name="$(parent)ScrollChild">
                            <OnInitialized>self:SetParent(self:GetParent():GetNamedChild("Scroll"));self:SetAnchor(3,nil,3,0,0)</OnInitialized>
                            <Controls>
                                <Control name="$(parent)Refine" hidden="true">
                                    <Anchor point="3" relativePoint="3" relativeTo="$(parent)" />
                                </Control>
                                <Control name="$(parent)Selection" hidden="true">
                                    <Anchor point="3" relativePoint="3" relativeTo="$(parent)" />
                                </Control>
                            </Controls>
                        </Control>
                    </Controls>
                </Backdrop>
                <Backdrop name="GlyphDivider" edgeColor="282828">
                    <Anchor point="3" relativePoint="3" relativeTo="$(parent)GlyphSection" offsetY="40" />
                    <Dimensions x="509" y="1" />
                    <Edge edgeSize="1" />
                </Backdrop>
                <Label name="$(parent)Info" font="CS4Font" color="E8DFAF" horizontalAlignment="2">
                    <Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-10" offsetY="5" />
                </Label>
                <Label name="$(parent)AmountLabel" text="" font="CS4Font" color="E8DFAF">
                    <Anchor point="2" relativePoint="2" relativeTo="$(parent)SearchAmount" offsetX="10" />
                    <OnInitialized>self:SetText(GetString(SI_TRADING_HOUSE_POSTING_QUANTITY)..":")</OnInitialized>
                </Label>
                <EditBox name="$(parent)Amount" font="CS4Font" color="E8DFAF" maxInputCharacters="2" inherits="ZO_DefaultEditForBackdrop ZO_EditDefaultText">
                    <Anchor point="2" relativePoint="8" relativeTo="$(parent)AmountLabel" offsetX="15" />
                    <Dimensions x="36" y="24" />
                    <OnFocusGained>self:SetText("")</OnFocusGained>
                    <Controls>
                        <Backdrop name="$(parent)BG" centerColor="000000" edgeColor="00000000">
                            <Dimensions x="40" y="30" />
                            <Anchor point="128" />
                            <Edge edgeSize="1" />
                        </Backdrop>
                    </Controls>
                </EditBox>
            </Controls>
        </TopLevelControl>
    </Controls>
</GuiXml>
