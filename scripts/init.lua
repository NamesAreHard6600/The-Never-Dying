
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
	--[[
	sprites.addMechs(
		{
			Name = "nuclear_box",
			Default = {PosX = -11, PosY = 7},
			Death = {PosX = -11, PosY = 7, NumFrames = 1, Loop = false},
			Animated = {PosX = -11, PosY = 7},
			Icon = {},
		},
		{
			Name = "Nuclear_Mech",
			Default = {PosX = -17, PosY = -6},
			Broken = {PosX = -17, PosY = -6, NumFrames = 1, Loop = true},
			Animated = {PosX = -17, PosY = -6, NumFrames = 4},
			Submerged = {PosX = -17, PosY = 10},
			SubmergedBroken = {PosX = -17, PosY = 7},
			Icon = {},
		},
		{
			Name = "Overload_Mech",
			Default = {PosX = -19, PosY = -6},
			Broken = {PosX = -19, PosY = -6, NumFrames = 1, Loop = true},
			Animated = {PosX = -19, PosY = -6, NumFrames = 4},
			Submerged = {PosX = -18, PosY = -1, NumFrames = 4},
			SubmergedBroken = {PosX = -18, PosY = -1},
			Icon = {},
		},
		{
			Name = "Recharge_Mech",
			Default = {PosX = -14, PosY = -15},
			Broken = {PosX = -17, PosY = -16, NumFrames = 1, Loop = true},
			Animated = {PosX = -14, PosY = -15, NumFrames = 8},
			Submerged = {PosX = -14, PosY = -1}, --Unused, cause flying, but I still need it
			SubmergedBroken = {PosX = -17, PosY = -12},
			Icon = {},
		}
	)
	]]--
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
	modApi:addSquadTrue({"The Never Dying", "MedicMech", "KamakazeMech", "ScreamMech"}, "The Never Dying", "With their Ultra Plated Armor, these mechs are capable of sustaining very high damage shots, allowing for powered up weapons.",self.resourcePath.."/squadIcon.png")
end

local function metadata()
	--modApi:addGenerationOption("NAH_NN_AttackOrder", "Attack Order Shows Energy", "Turn on or off whether or not pressing the attack order hotkey shows mechs Energy.", {values = {"On","Off"}})
end


return {
  id = "NamesAreHard - The Never Dying",
  name = "The Never Dying",
	icon = "modIcon.png",
	description = "With their Ultra Plated Armor, these mechs are capable of sustaining very high damage shots, allowing for powered up weapons.",
	modApiVersion = "2.9.1",
	gameVersion = "1.2.83",
	version = "0.2.0",
	requirements = { "kf_ModUtils" },
	dependencies = {
		modApiExt = "1.18",
		memedit = "1.0.2",
	},
  metadata = metadata,
	load = load,
	init = init
}
