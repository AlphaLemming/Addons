local lmb,rmb,mmb = '|t16:16:AlphaGearX2/lmb.dds|t','|t16:16:AlphaGearX2/rmb.dds|t','|t16:16:AlphaGearX2/mmb.dds|t'
AG4 = {
de = {
	Copy = 'Kopieren',
	Paste = 'Einfügen',
	Clear = 'Leeren',
	Insert = 'Aktuelle Ausrüstung einfügen',
	Icon = lmb..'Bild manuell auswählen',
	Set = lmb..' Set anlegen\n'..rmb..' Set bearbeiten',
	NotFound = '<<1>> |cFF0000konnte nicht gefunden werden...|r',
	NotEnoughSpace = '|cFFAA33AlphaGear|r |cFF0000Nicht genügend Taschenplatz...|r',
	SoulgemUsed = '<<C:1>> |cFFAA33wurde neu aufgeladen.|r',
	SetPart = 'Teil vom Set: <<C:1>>',
	Lock = 'Ist das Set gesperrt, werden leere Plätze ausgezogen.\nIst das Set entsperrt, werden leere Plätze ignoriert.\n\n'..lmb..' Sperren/Entsperren',
	SetConnector = {
		lmb..' Ausrüstung mit Set verbinden\n'..rmb..' Verbindung entfernen',
		lmb..' Aktionsleiste 1 mit Set verbinden\n'..rmb..' Verbindung entfernen',
		lmb..' Aktionsleiste 2 mit Set verbinden\n'..rmb..' Verbindung entfernen'
	},
	Head = {
		Gear = 'Ausrüstung ',
		Skill = 'Fähigkeiten '
	},
	Button = {
		Gear = lmb..' Gegenstand anlegen\n'..rmb..' Gegenstand entfernen',
		Skill = lmb..' Fähigkeit ausrüsten\n'..rmb..' Fähigkeit entfernen'
	},
	Selector = {
		Gear = lmb..' Gesamte Ausrüstung anlegen\n'..rmb..' Weitere Optionen',
		Skill = lmb..' Alle Fähigkeiten ausrüsten\n'..mmb..' Weitere Optionen'
	},
	OptionWidth = 310,
	Options = {
		SHOW_BUTTON			= 'UI-Button anzeigen',				-- 1
		SHOW_SET_BUTTONS	= 'UI-Set-Buttons anzeigen',			-- 2
		SHOW_REPAIR_ICON	= 'Reparatur-Icon anzeigen',			-- 3
		SHOW_REPAIR_COST	= 'Reparatur-Kosten anzeigen',		-- 4
		SHOW_CHARGE_STATUS	= 'Waffen-Ladung-Icon(s) anzeigen',	-- 5
		ROW1 = '-',
		SHOW_SET_SWAP		= 'Set-Wechsel-Meldung anzeigen',	-- 6
		SHOW_BAR_SWAR		= 'Waffenwechsel-Meldung anzeigen',
		SHOW_EQUIPPED_SET	= 'Angelegtes Set anzeigen',
		ROW2 = '-',
		MARK_INVENTORY		= 'Set-Items im Inventar markieren',	-- 9
		SHOW_CONDITION		= 'Item-Zustand in Prozent anzeigen',	-- 10
		SHOW_QUALITY		= 'Item-Qualität als Farbe anzeigen',	-- 11
		ROW3 = '-',
		MOVEMENT_CLOSE		= 'Fenster bei Bewegung schließen',	-- 13
		LOCK_INTERFACE		= 'Alle AlphaGear-Elemente sperren',	-- 7
		ROW4 = '-',
		AUTO_CHARGE			= 'Waffen automatisch aufladen',		-- 15
	}
},
en = {
	Copy = 'Copy',
	Paste = 'Paste',
	Clear = 'Clear',
	Insert = 'Insert currently equipped gear',
	Icon = lmb..'Choose icon',
	Set = lmb..' Equip set\n'..rmb..' Edit set',
	NotFound = '<<1>> |cFF0000was not found...|r',
	NotEnoughSpace = '|cFFAA33AlphaGear|r |cFF0000Not enough bag-space...|r',
	SoulgemUsed = '<<C:1>> |cFFAA33was recharged.|r',
	SetPart = 'Part of Set: <<C:1>>',
	Lock = 'If the set is locked, all empty slots will be unequipped.\nIf the set is unlocked, all empty slots will be ignored.\n\n'..lmb..' Lock/unlock',
	SetConnector = {
		lmb..' Connect gear with set\n'..rmb..' Remove connection',
		lmb..' Connect actionbar 1 with set\n'..rmb..' Remove connection',
		lmb..' Connect actionbar 2 with set\n'..rmb..' Remove connection'
	},
	Head = {
		Gear = 'Gear ',
		Skill = 'Skills '
	},
	Button = {
		Gear = lmb..' Equip item\n'..rmb..' Remove item',
		Skill = lmb..' Equip skill\n'..rmb..' Remove skill'
	},
	Selector = {
		Gear = lmb..' Equip entire gear\n'..rmb..' More options',
		Skill = lmb..' Equip all skills\n'..mmb..' More options'
	},
	OptionWidth = 300,
	Options = {
		SHOW_BUTTON			= 'Show UI-button',
		SHOW_SET_BUTTONS	= 'Show UI-set-buttons',
		SHOW_REPAIR_ICON	= 'Show repair icon',
		SHOW_REPAIR_COST	= 'Show repair cost',
		SHOW_CHARGE_STATUS	= 'Show weapon charge icon(s)',
		ROW1 = '-',
		SHOW_SET_SWAP		= 'Show set equip message',
		SHOW_BAR_SWAR		= 'Show weapon swap message',
		SHOW_EQUIPPED_SET	= 'Show equipped set',
		ROW2 = '-',
		MARK_INVENTORY		= 'Mark set items in inventory',
		SHOW_CONDITION		= 'Show item condition in percent',
		SHOW_QUALITY		= 'Show item quality as color',
		ROW3 = '-',
		MOVEMENT_CLOSE		= 'Close window on movement',
		LOCK_INTERFACE		= 'Lock all AlphaGear elements',
		ROW4 = '-',
		AUTO_CHARGE			= 'Automatic weapon charge'
	}
},
fr = {
	Copy = 'Copy',
	Paste = 'Paste',
	Clear = 'Clear',
	Insert = 'Placez l\'équipement actuellement équipé',
	Icon = lmb..'Sélectionnez l\'icône',
	Set = lmb..' Équiper l\'ensemble\n'..rmb..' Modifier l\'ensemble',
	NotFound = '<<1>> |cFF0000n\'a pas été trouvé...|r',
	NotEnoughSpace = '|cFFAA33AlphaGear|r |cFF0000Pas assez d\'espace d\'inventaire...|r',
	SoulgemUsed = '<<C:1>> |cFFAA33a été rechargé.|r',
	SetPart = 'Élément de l\'ensemble: <<C:1>>',
	Lock = 'Si l\'ensemble est verrouillé, tous les slots vides seront déséquipés.\nSi l\'ensemble est déverrouillé, tous les slots vides seront ignorés.\n\n'..lmb..' Verrouiller/Déverrouiller',
	SetConnector = {
		lmb..' Linker l\'équipement avec l\'ensemble\n'..rmb..' Supprimer le lien',
		lmb..' Linker la barre d\'action principale avec l\'ensemble\n'..rmb..' Supprimer le lien',
		lmb..' Linker la barre d\'action principale avec l\'ensemble\n'..rmb..' Supprimer le lien'
	},
	Head = {
		Gear = 'Équipement ',
		Skill = 'Compétences '
	},
	Button = {
		Gear = lmb..' Équiper l\'objet\n'..rmb..' Supprimer l\'objet',
		Skill = lmb..' Placer la compétence\n'..rmb..' Supprimer la compétence'
	},
	Selector = {
		Gear = lmb..' Équiper tout l\'équipement\n'..rmb..' plus d\'options',
		Skill = lmb..' Placer toutes les compétences\n'..mmb..' plus d\'options'
	},
	OptionWidth = 400,
	Options = {
		SHOW_BUTTON			= 'Afficher le bouton de l\'interface',
		SHOW_SET_BUTTONS	= 'Afficher les boutons d\'ensembles',
		SHOW_REPAIR_ICON	= 'Afficher l\'icône de réparation',
		SHOW_REPAIR_COST	= 'Afficher le coup de réparation',
		SHOW_CHARGE_STATUS	= 'Afficher les icônes de charge d\'arme',
		ROW1 = '-',
		SHOW_SET_SWAP		= 'Afficher le message de changement d\'équipement',
		SHOW_BAR_SWAR		= 'Afficher le message de switch d\'arme',
		SHOW_EQUIPPED_SET	= 'Afficher l\'ensemble porté',
		ROW2 = '-',
		MARK_INVENTORY		= 'Marquer les objets de set dans l\'inventaire',
		SHOW_CONDITION		= 'Afficher le taux d\'usure en pourcentage',
		SHOW_QUALITY		= 'Afficher la qualité de l\'objet en tant que couleur',
		ROW3 = '-',
		MOVEMENT_CLOSE		= 'Fermer la fenêtre au déplacement du personnage',
		LOCK_INTERFACE		= 'Verrouiller les éléments AlphaGear',
		ROW4 = '-',
		AUTO_CHARGE			= 'Rechargement automatique de l\'arme'
	}
}
