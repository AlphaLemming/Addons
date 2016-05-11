		<TopLevelControl hidden="true" clampedToScreen="true" movable="true" mouseEnabled="true" name="CS4_SetCraft" allowBringToTop="true">
			<Dimensions x="501" y="587" />
			<OnMouseUp>CraftStore.account.position[3] = {self:GetLeft(),self:GetTop()}</OnMouseUp>
			<Controls>
				<Backdrop name="$(parent)BG" centerColor="181818" edgeColor="00000000">
					<AnchorFill/>
					<Edge edgeSize="1" />
				</Backdrop>
				<Label name="$(parent)Headline" font="CS4Font" color="FFAA33">
					<Anchor point="1" relativePoint="1" relativeTo="$(parent)" offsetY="5" />
				</Label>
				<Button name="$(parent)CloseButton" clickSound="Click">
					<Anchor point="9" relativePoint="9" relativeTo="$(parent)" offsetX="-7" offsetY="4" />
					<Dimensions y="25" x="25" />
					<Textures normal="esoui/art/buttons/decline_up.dds" pressed="esoui/art/buttons/decline_down.dds" mouseOver="esoui/art/buttons/decline_over.dds" />
					<OnClicked>SCENE_MANAGER:HideTopLevel(CS4_SetCraft)</OnClicked>
				</Button>
				<Button name="$(parent)Header" verticalAlignment="1" horizontalAlignment="1" font="CS4Font">
					<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="35" />
					<Dimensions x="481" y="40" />
					<Textures normal="CraftStore4/grey.dds" />
					<FontColors normalColor="FFAA33" mouseOverColor="FFAA33" />
				</Button>
				<Button name="$(parent)Player" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Font">
					<Anchor point="3" relativePoint="6" relativeTo="$(parent)Header" offsetY="1" />
					<Dimensions x="230" y="32" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
				</Button>
				<Control name="$(parent)Traitinfo">
					<Anchor point="3" relativePoint="6" relativeTo="$(parent)Player" offsetY="1" />
					<Dimensions x="230" y="164" />
				</Control>
				<Backdrop name="$(parent)List" centerColor="383838" edgeColor="00383838" inherits="ZO_ScrollContainerBase">
					<Anchor point="9" relativePoint="12" relativeTo="$(parent)Header" offsetY="1" />
					<Dimensions x="250" y="350" />
					<Edge edgeSize="1" />
					<OnInitialized>ZO_Scroll_Initialize(self)</OnInitialized>
					<Controls>
						<Control name="$(parent)ScrollChild">
							<OnInitialized>self:SetParent(self:GetParent():GetNamedChild("Scroll"));self:SetAnchor(3,nil,3,0,0)</OnInitialized>
						</Control>
					</Controls>
				</Backdrop>
				<Backdrop name="$(parent)Info" centerColor="383838" edgeColor="00383838" inherits="ZO_ScrollContainerBase">
					<Anchor point="9" relativePoint="12" relativeTo="$(parent)List" offsetY="1" />
					<Dimensions x="481" y="150" />
					<Edge edgeSize="1" />
					<OnInitialized>ZO_Scroll_Initialize(self)</OnInitialized>
					<Controls>
						<Control name="$(parent)ScrollChild">
							<OnInitialized>self:SetParent(self:GetParent():GetNamedChild("Scroll"));self:SetAnchor(3,nil,3,0,0)</OnInitialized>
							<Controls>
								<Label name="$(parent)Text" font="CS4Font" color="FFFFFF">
									<Anchor point="3" relativePoint="3" relativeTo="$(parent)" offsetX="10" offsetY="10" />
								</Label>
							</Controls>
						</Control>
					</Controls>
				</Backdrop>
				<Button name="$(parent)Shrine1" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Font">
					<Anchor point="1" relativePoint="4" relativeTo="$(parent)Traitinfo" offsetY="1" />
					<Dimensions x="230" y="50" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
				</Button>
				<Button name="$(parent)Shrine2" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Font">
					<Anchor point="1" relativePoint="4" relativeTo="$(parent)Shrine1" offsetY="1" />
					<Dimensions x="230" y="50" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
				</Button>
				<Button name="$(parent)Shrine3" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Font">
					<Anchor point="1" relativePoint="4" relativeTo="$(parent)Shrine2" offsetY="1" />
					<Dimensions x="230" y="50" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
				</Button>
			</Controls>
		</TopLevelControl>
