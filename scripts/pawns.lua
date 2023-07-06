local path = mod_loader.mods[modApi.currentMod].scriptPath



local pawnColor = modApi:getPaletteImageOffset("TheNeverDying")
--Mechs

KamakazeMech = Pawn:new {
	Name = "Kamakaze Mech",
	Class = "Ranged",
	Image = "MechArt",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Huge_Artillery"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/punch_mech/",
	Massive = true,
	Flying = false
}
AddPawn("KamakazeMech")

ScreamMech = Pawn:new {
	Name = "Scream Mech",
	Class = "Science",
	Image = "MechScience",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Piercing_Screech"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/laser_mech/",
	Massive = true,
	Flying = true
}
AddPawn("ScreamMech")

MedicMech = Pawn:new {
	Name = "Medic Mech",
	Class = "Brute",
	Image = "MechMirror",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 4,
	SkillList = {"Support_Weapon", "Ultra_Plated_Armor"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	SoundLocation = "/mech/science/science_mech/",
	Flying = false
}
AddPawn("SupportMech")
