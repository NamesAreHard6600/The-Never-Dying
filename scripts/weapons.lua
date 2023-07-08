--Functions and Variables
local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local taunt = require(scriptPath.."taunt/taunt")
--taunt = require(scriptPath.."taunt/taunt")

--TODO:
--Sounds
--Weapon Names
--Support Weapon needs major animation work

Huge_Artillery = Skill:new{
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
	Upgrades = 1,
	Missle = "effects/shotup_guided_missile.png",
	--UpgradeList = {"Remove Recoil",}, Other ideas welcome    Death Damage? 3 cores
	UpgradeCost = { 2 },

	--Custom Variables
	Recoil = true,
	RecoilProtection = false,
	BuildingImmune = false,

	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2,1),
		Mountain = Point(2,4),
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
	local dir = GetDirection(p2 - p1)
	local backdir = GetDirection(p1 - p2)
	local target = p2

	-- Self Damage
	local damage = SpaceDamage(p1, self.SelfDamage)
	damage.sAnimation = "ExploArt1"
	if self.Recoil then
		damage.iPush = backdir
	end
	ret:AddDamage(damage)

	-- Damage
	local damage = SpaceDamage(p2, self.Damage)
	if self.BuildingImmune and Board:GetTerrain(p2) == TERRAIN_BUILDING then
		damage = SpaceDamage(p2)
	else
		damage.sAnimation = "ExploArt3"
	end
	ret:AddArtillery(damage, self.Missle)

	--Push
	for i=DIR_START, DIR_END do
		local damage = SpaceDamage(p2+DIR_VECTORS[i],0,i)
		damage.sAnimation = "airpush_"..i
		ret:AddDamage(damage)
	end

	--ISSUE: Shield?? I'm not sure what this comment means
	local recoilSpace = p1+DIR_VECTORS[backdir]
	if self.RecoilProtection and Board:IsValid(recoilSpace) and Board:IsBlocked(recoilSpace,PATH_PROJECTILE) then
		damage = SpaceDamage(p1,-1)
		ret:AddDamage(damage)
	end

	return ret
end

Huge_Artillery_A = Huge_Artillery:new {
	RecoilProtection = true,
}

--Huge_Artillery_B = Huge_Artillery:new {
--	Recoil = false,
--}

--Huge_Artillery_AB = Huge_Artillery:new {
--	BuildingImmune = true,
--	Recoil = false,
--}

Piercing_Screech = Skill:new{
	Class = "Science",
	Icon = "weapons/science_pushbeam.png",
	LaserArt = "effects/laser_push",
	Rarity = 3, --Change
	Explosion = "",
	LaunchSound = "/weapons/push_beam",
	Damage = 0,
	PathSize = 10,
	PowerCost = 1,
	Upgrades = 2,
	--UpgradeList = {Sheild Self, Dash},
	UpgradeCost = {2,2},

	--Custom Variables
	Shield = false,
	Dash = false,

	CustomTipImage = "Piercing_Screech_Tip",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,0),
		Enemy3 = Point(1,2),
		Target = Point(2,3),
		Building = Point(1,0),
		Building2 = Point(3,1),
		CustomEnemy = "Firefly2", --"Scorpion2",
	}
}

function Piercing_Screech:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local id = Pawn:GetId()
	ret:push_back(point)

	if self.Dash then
		for i = DIR_START, DIR_END do
			for k = 1, 8 do
				local curr = DIR_VECTORS[i]*k + point
				if Board:IsValid(curr) and not Board:IsBlocked(curr, PATH_PROJECTILE) then
					ret:push_back(DIR_VECTORS[i]*k + point)
				else
					break
				end
			end
		end
	end

	return ret
end

function Piercing_Screech:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	if self.Shield then
		local damage = SpaceDamage(p1)
		damage.iShield = EFFECT_CREATE
		ret:AddDamage(damage)
	end


	if self.Dash then
		ret:AddCharge(Board:GetSimplePath(p1, p2), FULL_DELAY)
	end

	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + p2
			if Board:IsValid(curr) and curr ~= p1 then
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				pawn = Board:GetPawn(curr)
				if pawn ~= nil then
					taunt.addTauntEffectSpace(ret, curr, p2, self.Damage, true)
				end
			else
				break
			end
		end
	end

	return ret
end

Piercing_Screech_A = Piercing_Screech:new {
	Damage = 1,
	CustomTipImage = "Piercing_Screech_Tip_A",
}

Piercing_Screech_B = Piercing_Screech:new {
	Dash = true,
	CustomTipImage = "Piercing_Screech_Tip_B",
}

Piercing_Screech_AB = Piercing_Screech:new {
	Damage = 1,
	Dash = true,
	CustomTipImage = "Piercing_Screech_Tip_AB",
}

--Hellish Tip Imaging
Piercing_Screech_Tip = Piercing_Screech:new {}
Piercing_Screech_Tip_A = Piercing_Screech_Tip:new {Damage = 1,}
Piercing_Screech_Tip_B = Piercing_Screech_Tip:new {
	Dash = true,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,0),
		Enemy3 = Point(1,2),
		Target = Point(2,2),
		Building = Point(1,0),
		Building2 = Point(3,1),
		CustomEnemy = "Firefly2", --"Scorpion2",
	},
}
Piercing_Screech_Tip_AB = Piercing_Screech_Tip_B:new {Damage = 1,}


function Piercing_Screech_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = 2

	Board:GetPawn(Point(2,0)):FireWeapon(Point(1,0),1)
	Board:GetPawn(Point(2,1)):FireWeapon(Point(3,1),1)
	Board:GetPawn(Point(1,2)):FireWeapon(Point(1,1),1)

	if self.Shield then
		local damage = SpaceDamage(p1)
		damage.iShield = EFFECT_CREATE
		ret:AddDamage(damage)
	end

	if self.Dash then
		ret:AddCharge(Board:GetSimplePath(p1, p2), FULL_DELAY)
		ret:AddScript("Board:GetPawn(Point(1,2)):SetQueuedTarget(Point(2,2))")
	end

	ret:AddScript("Board:GetPawn(Point(2,0)):SetQueuedTarget(Point(2,1))")
	ret:AddScript("Board:GetPawn(Point(2,1)):SetQueuedTarget(Point(2,2))")

	local animation = SpaceDamage(p2)
	animation.sAnimation = "taunting"
	ret:AddDamage(animation)
	animation.sAnimation = "taunted"
	animation.sImageMark = "combat/icons/tauntIcon_"..tostring(dir).."_d.png"
	animation.loc = Point(2,1)
	animation.iDamage = self.Damage
	ret:AddDamage(animation)
	animation.loc = Point(2,0)
	ret:AddDamage(animation)
	if self.Dash then
		animation.loc = Point(1,2)
		animation.sImageMark = "combat/icons/tauntIcon_"..tostring(1).."_d.png"
		ret:AddDamage(animation)
	end

	return ret
end


Support_Weapon = Skill:new {
	Icon = "weapons/science_pullmech.png",
	Class = "Brute",
	Rarity = 3,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,2}, --Very Cheap Upgrades
	Damage = 1,
	Healing = 1,
	--UpgradeList {"Extra Projectiles","+1 damage/heal"}

	--Custom Variables
	SelectiveHeals = false,
	DamageProjectile = "effects/shot_mechtank",
	HealProjectile = "effects/shot_tankacid",

	TipImage = {
		Unit = Point(2,2),
		Enemy = Point (2,1),
		Target = Point(2,1),
		Friendly_Damaged = Point(2,3),
		Enemy2_Damaged = Point(1,2),
	}
}

function Support_Weapon:GetTargetArea(point)
	local ret = PointList()

	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) and not Board:IsBlocked(curr, PATH_PROJECTILE) then
				ret:push_back(curr)
			else
				if Board:IsValid(curr) then
					ret:push_back(curr)
				end
				break
			end
		end
	end

	return ret
end

function Support_Weapon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	local backdir = GetDirection(p1-p2)
	local target = GetProjectileEnd(p1,p2)
	local heals = {
		GetProjectileEnd(p1,p1+DIR_VECTORS[backdir]),
		GetProjectileEnd(p1,p1+DIR_VECTORS[(backdir+1)%4]),
		GetProjectileEnd(p1,p1+DIR_VECTORS[(backdir-1)%4])
	}
	--[[
	if self.ExtraShots then
		table.insert(heals,GetProjectileEnd(p1,p1+DIR_VECTORS[(backdir+1)%4]))
		table.insert(heals,GetProjectileEnd(p1,p1+DIR_VECTORS[(backdir-1)%4]))
	end]]--

	local damage = SpaceDamage(target,self.Damage,dir)
	ret:AddProjectile(damage,self.DamageProjectile,NO_DELAY)

	for _, point in ipairs(heals) do
		if point ~= p1 then
			local heal = SpaceDamage(point,-self.Healing)
			local pawn = Board:GetPawn(point)
			if self.SelectiveHeals and pawn and pawn:GetTeam() == TEAM_ENEMY then
				heal.iDamage = 0
			else
				heal.iFire = EFFECT_REMOVE
				heal.iAcid = EFFECT_REMOVE
			end
			ret:AddProjectile(heal,self.HealProjectile,NO_DELAY)
		end
	end

	return ret
end

Support_Weapon_A = Support_Weapon:new {
	SelectiveHeals = true,
}

Support_Weapon_B = Support_Weapon:new {
	Damage = 2,
	Healing = 2,
}

Support_Weapon_AB = Support_Weapon:new {
	SelectiveHeals = true,
	Damage = 2,
	Healing = 2,
}


Ultra_Plated_Armor = PassiveSkill:new {
	Passive = "NAH_Ultra_Plated_Armor",
	Icon = "weapons/passives/passive_flameimmune.png",
	PowerCost = 1,
	Upgrades = 1,
	UpgradeCost = {3},
	--UpgradesList = {"Shield"}, Add a shield after almost dying
	--Provide a shield after avoiding death.
	Shield = false,
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2),
	}
}

Ultra_Plated_Armor_A = Ultra_Plated_Armor:new {
	Passive = "NAH_Ultra_Plated_Armor_A",
	Shield = true,
	--Make sure hooks check the proper upgrades
}

function Ultra_Plated_Armor:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local pawn = Board:GetPawn(p1)
	local id = pawn:GetId()
	local max_health = 2
	pawn:SetMaxHealth(2)

	local damage = SpaceDamage(p1,3)
	damage.sImageMark = "icons/NAH_Protected.png"
	ret:AddMelee(Point(2,1),damage)
	--ret:AddDelay(0.0167)

	ret:AddScript(string.format([[
		local pawn = Board:GetPawn(%s)
		pawn:SetMaxHealth(%s)
		pawn:SetHealth(1)
	]],tostring(id),tostring(max_health)))

	if self.Shield then
		local damage = SpaceDamage(p1)
		damage.iShield = EFFECT_CREATE
		ret:AddDamage(damage)
	end

	return ret
end
