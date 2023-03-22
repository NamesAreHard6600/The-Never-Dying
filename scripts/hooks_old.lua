--Just Template Stuff Not Used at the moment

--Damaged healed, damaged
local this = {}
local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

--I may not need armorDetection now that I know how passives work and can just have it be a passive
local armorDetection = require(scriptPath .."libs/armorDetection")



local function PassiveActive()
	for id = 0, 2 do
		pawn = Board:GetPawn(id)
		if (armorDetection.HasPoweredWeapon(pawn, "Ultra_Plated_Armor") or
		armorDetection.HasPoweredWeapon(pawn, "Ultra_Plated_Armor_A") or
		armorDetection.HasPoweredWeapon(pawn, "Ultra_Plated_Armor_B") or
		armorDetection.HasPoweredWeapon(pawn, "Ultra_Plated_Armor_AB")) then
			return true
		end
	end
	return false
end

--[[
local function setVariables(mission)
	mission.NAH_TND_Max = mission.NAH_TND_Max or {}
	for id = 0, 2 do
		mission.NAH_TND_MaxHealth[id] = Board:GetPawn(id):GetHealth()
	end
end
--]]
local function resetVariables(mission)
	mission.NAH_TND_Max = mission.NAH_TND_Max or {} --Won't set False
	for id = 0, 2 do
		if not Board:GetPawn(id):IsDamaged() then
			mission.NAH_TND_Max[id] = true
		else
			mission.NAH_TND_Max[id] = false
		end
	end
end



local function pawnDamaged(mission, pawn, damageTaken)
	if (pawn:IsMech() and PassiveActive() and mission.NAH_TND_Max[pawn:GetId()]) then
		if (pawn:GetHealth() < 1) then
			pawn:SetHealth(1)
			mission.NAH_TND_Max[pawn:GetId()] = false
		end
	end

end



function this:load()

    NAH_TND_ModApiExt:addPawnDamagedHook(pawnDamaged)
	modApi:addNextTurnHook(resetVariables)
	modApi:addTestMechEnteredHook(resetVariables)
	--modApi:addMissionStartHook(setVariables)
end

return this
