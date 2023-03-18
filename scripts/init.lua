
local function init(self)
	--init variables
	local path = mod_loader.mods[modApi.currentMod].scriptPath
	--libs
	local sprites = require(path .."libs/sprites")
	local mod = mod_loader.mods[modApi.currentMod]
	local resourcePath = mod.resourcePath
	local scriptPath = mod.scriptPath
	local options = mod_loader.currentModContent[mod.id].options
	
	--ModApiExt
	if modApiExt then
		-- modApiExt already defined. This means that the user has the complete
		-- ModUtils package installed. Use that instead of loading our own one.
		NAH_TND_ModApiExt = modApiExt
	else
		-- modApiExt was not found. Load our inbuilt version
		local extDir = self.scriptPath.."modApiExt/"
		NAH_TND_ModApiExt = require(extDir.."modApiExt")
		NAH_TND_ModApiExt:init(extDir)
	end
	if not taunt then
		taunt = require(scriptPath.."taunt/taunt")
	end
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
	
	--Nuclear Nightmares Palette for now
	modApi:addPalette{
		ID = "TheNeverDying",
		Name = "The Never Dying",
		PlateHighlight = {  6, 255,  50}, --{ 35, 248, 255},
		PlateLight     = {221, 188,  65}, --{219, 204,  86}, 
		PlateMid       = {159, 128,  62}, --{212, 212,   0}, 
		PlateDark      = { 74,  64,  53}, --{189, 167,   0}, 
		PlateOutline   = { 15,  22,  16}, --{  2,   2,   1},
		PlateShadow    = { 69,  74,  57}, --{ 16,  17,  16},
		BodyColor      = {109, 109,  94}, 
		BodyHighlight  = {152, 153, 131}, 
	}
	
	--Scripts
	require(self.scriptPath.."LApi/LApi")
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."tauntTorrent")

	--require(self.scriptPath.."animations")
	--require(self.scriptPath.."hooks")
	
	
	--Weapon Icons
	modApi:appendAsset("img/icons/retarget.png", self.resourcePath.."img/icons/retarget.png")
	
	
	--modApi:addWeaponDrop("Name")
	

end
local function load(self,options,version)
	NAH_TND_ModApiExt:load(self, optoins, version)
	require(self.scriptPath .. "hooks"):load()
	require(self.scriptPath .."weaponPreview/api"):load()
	
	
	modApi:addSquadTrue({"The Never Dying", "ScreamMech", "RangedMech", "SupportMech"}, "The Never Dying", "With ultra plated armor, these mechs are capable of sustaining very high damage shots, and attract the shots of vek to support this.",self.resourcePath.."/squadIcon.png")
	
end

local function metadata()
	--modApi:addGenerationOption("NAH_NN_AttackOrder", "Attack Order Shows Energy", "Turn on or off whether or not pressing the attack order hotkey shows mechs Energy.", {values = {"On","Off"}})
end


return {
    id = "NamesAreHard - The Never Dying",
    name = "The Never Dying",
	icon = "modIcon.png",
	description = "With ultra plated armor, these mechs are capable of sustaining very high damage shots, and attract the shots of vek to support this.",
    version = "0.0.1",
	requirements = { "kf_ModUtils" },
    metadata = metadata,
	load = load,
	init = init
}