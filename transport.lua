		<TopLevelControl hidden="true" mouseEnabled="true" name="CS4_Commander" topmost="true">
			<Anchor point="128" relativePoint="128" relativeTo="GuiRoot" />
			<Dimensions x="350" y="350" />
			<Controls>
				<Texture name="$(parent)BG"><AnchorFill /></Texture>
				<Texture name="$(parent)Logo">
					<Anchor point="128" relativePoint="1" relativeTo="$(parent)" />
					<Dimensions y="128" x="128" />
				</Texture>
				<Button name="$(parent)Button1" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="1" relativeTo="$(parent)" offsetY="100" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_Panel)</OnClicked>
				</Button>
				<Button name="$(parent)Button2" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="4" relativeTo="$(parentButton1" offsetY="5" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_Style)</OnClicked>
				</Button>
				<Button name="$(parent)Button3" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="4" relativeTo="$(parentButton2" offsetY="5" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_SetCraft)</OnClicked>
				</Button>
				<Button name="$(parent)Button4" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="4" relativeTo="$(parentButton3" offsetY="5" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_Cook)</OnClicked>
				</Button>
				<Button name="$(parent)Button5" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="4" relativeTo="$(parentButton4" offsetY="5" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_Rune)</OnClicked>
				</Button>
				<Button name="$(parent)Button6" clickSound="Click" verticalAlignment="1" horizontalAlignment="1" font="CS4Bold">
					<Anchor point="1" relativePoint="4" relativeTo="$(parentButton5" offsetY="5" />
					<Textures normal="CraftStore4/grey.dds" mouseOver="CraftStore4/over.dds" />
					<FontColors normalColor="FFFFFF" mouseOverColor="FFAA33" />
					<Dimensions y="300" x="40" />
					<OnClicked>SCENE_MANAGER:ToggleTopLevel(CS4_Flask)</OnClicked>
				</Button>
			</Controls>
		</TopLevelControl>
