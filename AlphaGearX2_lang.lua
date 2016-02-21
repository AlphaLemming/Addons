local lmb,rmb,mmb = '|t16:16:AlphaGearX2/lmb.dds|t','|t16:16:AlphaGearX2/rmb.dds|t','|t16:16:AlphaGearX2/mmb.dds|t'
AG4 = {
de = {
	Copy = 'Kopieren',
	Paste = 'Einfügen',
	Clear = 'Leeren',
	Rename = 'Umbenennen',
	Insert = 'Aktuelle Ausrüstung einfügen',
	ConnectGear = 'Ausrüstung zuweisen',
	ConnectSkill1 = 'Aktionsleiste 1 zuweisen',
	ConnectSkill2 = 'Aktionsleiste 2 zuweisen',
	Edit = lmb..' Set anlegen\n'..rmb..' Set-Namen ändern',
	Set = lmb..' Set anlegen\n'..rmb..' Set bearbeiten',
	NotFound = '<<1>> konte nicht gedunden werden...',
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
	NotEnoughSpace = '|cFFAA33AlphaGear|r |cFF0000Nicht genügend Taschenplatz...|r',
	SoulgemUsed = '<<C:1>> |cFFAA33wurde neu aufgeladen.|r',
	Options = {
		'UI-Button anzeigen',				-- 1
		'UI-Set-Button anzeigen',			-- 2
		'Reparatur-Icon anzeigen',			-- 3
		'Reparatur-Kosten anzeigen',		-- 4
		'Waffen-Ladung-Icon(s) anzeigen',	-- 5
		'Waffenwechsel-Meldung anzeigen',	-- 6
		'Alle Interface-Elemente sperren',	-- 7
		'-',
		'Set-Items im Inventar markieren',	-- 9
		'Item-Zustand in Prozent anzeigen',	-- 10
		'Item-Qualität als Farbe anzeigen',	-- 11
		'-',
		'Fenster bei Bewegung schließen',	-- 13
		'-',
		'Waffen automatisch aufladen',		-- 15
	}
},
en = {
	Button = {
		Gear = lmb..' Equip this gear\n'..mmb..' Clear this slot',
		skill = lmb..' Equip this skill\n'..mmb..' Clear this slot'
	},
	Selector = {
		Gear = lmb..' Equip this entire gear-set\n'..mmb..' Clear this entire set',
		Skill = lmb..' Equip this entire skill-set\n'..mmb..' Clear this entire set'
	}
}
}
