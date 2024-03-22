
local function init(self)
	--init variables
	local path = mod_loader.mods[modApi.currentMod].scriptPath
	--libs
	local sprites = require(path .."libs/sprites")
	local mod = mod_loader.mods[modApi.currentMod]
	local resourcePath = mod.resourcePath
	local scriptPath = mod.scriptPath
	local options = mod_loader.currentModContent[mod.id].options


	--Sprites
	sprites.addMechs(
		{
			Name = "Medic_Mech",
			Default = {PosX = -22, PosY = -5},
			Broken = {PosX = -22, PosY = -5, NumFrames = 1, Loop = true},
			Animated = {PosX = -22, PosY = -5, NumFrames = 4},
			Submerged = {PosX = -22, PosY = 2},
			SubmergedBroken = {PosX = -22, PosY = 10},
			Icon = {},
		},
		{
			Name = "Kamikaze_Mech",
			Default = {PosX = -21, PosY = -14},
			Broken = {PosX = -21, PosY = -14, NumFrames = 1, Loop = true},
			Animated = {PosX = -21, PosY = -14, NumFrames = 4},
			Submerged = {PosX = -21, PosY = -6},
			SubmergedBroken = {PosX = -21, PosY = -8},
			Icon = {},
		},
		{
			Name = "Scream_Mech",
			Default = {PosX = -22, PosY = -3},
			Broken = {PosX = -22, PosY = -3, NumFrames = 1, Loop = true},
			Animated = {PosX = -22, PosY = -3, NumFrames = 4},
			Submerged = {PosX = -15, PosY = 13}, --Unused, cause flying, but I still need it
			SubmergedBroken = {PosX = -20, PosY = -2},
			Icon = {},
		}
	)

	--Spiny Boys
	modApi:appendAsset("img/units/player/Medic_Mech_Spin.png", self.resourcePath.."img/units/player/Medic_Mech_Spin.png")
	ANIMS.Medic_Mech_Spin = ANIMS.MechUnit:new{ Image = "units/player/Medic_Mech.png", PosX = -22, PosY = -5 }
	ANIMS.Medic_Mech_Spina = ANIMS.MechUnit:new{ Image = "units/player/Medic_Mech_Spin.png", PosX = -22, PosY = -5, NumFrames = 8, Time=.08}
	--MechPunch1w =		MechUnit:new{ Image = "units/player/mech_punch_1w.png", PosX = -17, PosY = 10 }
	--MechPunch1_broken = 	MechUnit:new{ Image = "units/player/mech_punch_1_broken.png", PosX = -17, PosY = -1 }
	--MechPunch1w_broken = 	MechUnit:new{ Image = "units/player/mech_punch_1w_broken.png", PosX = -17, PosY = 10 }
	--MechPunch1_ns = 	MechIcon:new{ Image = "units/player/mech_punch_1_ns.png" }

	--Palette

	modApi:addPalette{
		ID = "TheNeverDying",
		Name = "The Never Dying",
		PlateHighlight = {0, 142, 255},
		PlateLight = {5, 215, 0},
		PlateMid = {38, 150, 5},
		PlateDark = {17, 77, 53},
		PlateOutline = {15, 35, 16},
		PlateShadow = {69, 91, 57},
		BodyColor = {109, 128, 94},
		BodyHighlight = {159, 167, 131},
	}

	--Scripts
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."tauntTorrent")
	require(self.scriptPath.."hooks")
	require(self.scriptPath.."achievements")
	require(self.scriptPath.."animations")

	modApi:addWeapon_Texts(require(self.scriptPath.."weapons_text"))

	self.libs = {}
	self.libs.modApiExt = modapiext
	NAH_TND_ModApiExt = self.libs.modApiExt
	self.libs.weaponPreview = require(self.scriptPath.."libs/".."weaponPreview")

	--Icons
	--modApi:appendAsset("img/icons/retarget.png", self.resourcePath.."img/icons/retarget.png")
	modApi:appendAsset("img/icons/NAH_Protected.png", self.resourcePath.."img/icons/NAH_Protected.png")
		Location["icons/NAH_Protected.png"] = Point(-11,-5)
	modApi:appendAsset("img/icons/NAH_Protected_Fail.png", self.resourcePath.."img/icons/NAH_Protected_Fail.png")
		Location["icons/NAH_Protected_Fail.png"] = Point(-11,-5)
	modApi:appendAsset("img/icons/NAH_damage_1_boost.png", self.resourcePath.."img/icons/NAH_damage_1_boost.png")
		Location["icons/NAH_damage_1_boost.png"] = Point(-9,10)
	modApi:appendAsset("img/icons/NAH_Boost_Protected.png", self.resourcePath.."img/icons/NAH_Boost_Protected.png")
		Location["icons/NAH_Boost_Protected.png"] = Point(-9,-11)
	--modApi:addWeaponDrop("Name")


end
local function load(self,options,version)
	modApi:addSquadTrue({"The Never Dying", "MedicMech", "KamikazeMech", "ScreamMech", id = "NAH_TheNeverDying"}, "The Never Dying", "With their Ultra Plated Armor, these mechs are capable of sustaining very high damage shots, allowing for powered up weapons.",self.resourcePath.."/squadIcon.png")
end

local function metadata()
	--modApi:addGenerationOption("NAH_NN_AttackOrder", "Attack Order Shows Energy", "Turn on or off whether or not pressing the attack order hotkey shows mechs Energy.", {values = {"On","Off"}})
end


return {
  id = "NamesAreHard - The Never Dying",
  name = "The Never Dying",
	icon = "modIcon.png",
	description = "Scrapped together by loose pieces found around Archive, these mechs have fortified hulls from all the metal strapped on to them. With their Ultra Plated Armor, these mechs are capable of sustaining very high damage shots, powering up their weapons to the next level.",
	modApiVersion = "2.9.1",
	gameVersion = "1.2.83",
	version = "0.3.0",
	requirements = { "kf_ModUtils" },
	dependencies = {
		modApiExt = "1.18",
		memedit = "1.0.2",
	},
  metadata = metadata,
	load = load,
	init = init
}
