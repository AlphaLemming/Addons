EM:RegisterForEvent('CraftStore_HideOnMove',EVENT_NEW_MOVEMENT_IN_UI_MODE, function()
	if CraftStore.account.option[11] then
		SM:HideTopLevel(CS4_Panel)
		SM:HideTopLevel(CS4_Style)
		SM:HideTopLevel(CS4_Sets)
		SM:HideTopLevel(CS4_Cook)
		SM:HideTopLevel(CS4_Rune)
		SM:HideTopLevel(CS4_Flask)
	end
end)
EM:UnregisterForEvent('CraftStore_HideOnMove',EVENT_NEW_MOVEMENT_IN_UI_MODE)

