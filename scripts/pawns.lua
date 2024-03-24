local path = mod_loader.mods[modApi.currentMod].scriptPath



local pawnColor = modApi:getPaletteImageOffset("TheNeverDying")
--Mechs

KamikazeMech = Pawn:new {
	Name = "Kamikaze Mech",
	Class = "Ranged",
	Image = "Kamikaze_Mech",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Huge_Artillery", "Ultra_Plated_Armor"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/punch_mech/",
	Massive = true,
	--Armor = true,
}
AddPawn("KamikazeMech")

ScreamMech = Pawn:new {
	Name = "Scream Mech",
	Class = "Science",
	Image = "Scream_Mech",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Piercing_Screech"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/laser_mech/",
	Massive = true,
	Flying = true,
	Armor = true,
}
AddPawn("ScreamMech")

MedicMech = Pawn:new {
	Name = "Medic Mech",
	Class = "Brute",
	Image = "Medic_Mech",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Support_Weapon"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	SoundLocation = "/mech/science/science_mech/",
	--Armor = true,
}
AddPawn("SupportMech")
