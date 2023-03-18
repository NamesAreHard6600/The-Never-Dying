--Functions and Variables
local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local taunt = require(scriptPath.."taunt/taunt")
--taunt = require(scriptPath.."taunt/taunt")


local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end



Huge_Artillery = Skill:new{
	Name = "Huge Artillery",
	Description = "Launch a massivily damaging shot, at the cost of your own life.",
	Class = "Ranged",
	Icon = "weapons/ranged_artillery.png",
	Rarity = 3, --Change
	Explosion = "",
	LaunchSound = "/weapons/artillery_volley", --Change
	PathSize = 1,
	Damage = 4, -- Tooltip
	SelfDamage = 5,
	--Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 0,
	Missle = "effects/shotup_guided_missile.png",
	--UpgradeList = {"+1 tile","+1 tile"},
	--UpgradeCost = { 2 },

	--Custom Variables

	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

function Huge_Artillery:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local center = point

	local ret = PointList()
	local mission = GetCurrentMission()


	for i = DIR_START, DIR_END do
		for k = 2, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) then
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end

	return ret
end
function Huge_Artillery:GetSkillEffect(p1, p2) --Make this look pretty : Explosion stuff, bounce, etc. Check Ranged_Rocket in weapons_ranged
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p2

	-- Self Damage
	local damage = SpaceDamage(p1, self.SelfDamage)
	ret:AddDamage(damage)

	-- Damage
	local damage = SpaceDamage(p2, self.Damage)
	ret:AddArtillery(damage, self.Missle)

	return ret
end

Piercing_Screech = Skill:new{
	Name = "Piercing Screech",
	Description = "All Vek in the same row or column get taunted towards the mech.",
	Class = "Brute",
	Icon = "weapons/science_pushbeam.png",
	LaserArt = "effects/laser_push",
	Rarity = 3, --Change
	Explosion = "",
	LaunchSound = "/weapons/push_beam",
	Damage = 1,
	PathSize = 10,
	PowerCost = 1,
	Upgrades = 0,
	--UpgradeList = {Sheild Self, },
	--UpgradeCost = {2, 3},

	--Custom Variables
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1),
		Enemy3 = Point(2,0),
		CustomEnemy = "Firefly2", --"Scorpion2",
	}
}

function Piercing_Screech:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local id = Pawn:GetId()
	ret:push_back(point)

	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) then
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			else
				break
			end
		end
	end
	return ret


end

function Piercing_Screech:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + p1
			if Board:IsValid(curr) then
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				pawn = Board:GetPawn(curr)
				if pawn ~= nil then
					taunt.addTauntEffectSpace(ret, curr, p1)
				end
			else
				break
			end
		end
	end

	--[[
	local pawn = Board:GetPawn(p2)
	if pawn then
		local id = pawn:GetId()
		-- damage = SpaceDamage(curr,0) --Remove Old Webs
		taunt.addTauntEffectEnemy(ret, id, p1)
		-- ret:AddDamage(damage)
	end
	]]--

	return ret
end



Support_Weapon = Skill:new {
	Name = "Support Weapon",
	Description = "Shoot a bullet in two directions. One heals while one pushes and damages.",
	Icon = "weapons/science_pullmech.png",
	Class = "Science",
	Rarity = 3,
	PowerCost = 1,
	Upgrades = 0,
	--UpgradeCost = {1,2},
	--UpgradeList {"Exploding Heal","+1 damage"}

	--Custom Variables

	TipImage = {
		Unit = Point(2,3),
		Target = Point(3,2),
		Enemy = Point (2,2),
		Second_Origin = Point(3,2),
		Second_Target = Point(3,2),
	}
}

function Support_Weapon:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local center = point

	local ret = PointList()
	local mission = GetCurrentMission()


	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) and Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN then --And some other stuff, I'll fix it later
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			else
				break
			end
		end
	end

	return ret
end

function Support_Weapon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()

	return ret
end


Ultra_Plated_Armor = Skill:new { --Passive Still Triggers Death Voice Line
	Name = "Ultra Plated Armor",
	Description = "If at max health (and not 1), survive any hit with 1 health left, including kill damage.",
	Icon = "weapons/passives/passive_flameimmune.png",
	PowerCost = 1,
	TipImage = {
		Unit = Point(2,3),
	}
}
