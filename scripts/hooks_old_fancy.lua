local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local armorDetection = require(scriptPath .."libs/armorDetection")

local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

--Board:AddPawn("Jelly_Boost1",Point(6,6))
local function HOOK_SkillBuild(mission, attackingPawn, weaponId, p1, p2, skillEffect)
	if IsPassiveSkill("NAH_Ultra_Plated_Armor") then
		local effects = {skillEffect.effect,skillEffect.q_effect}
		local base_offset = 0
		if attackingPawn and attackingPawn:IsBoosted() then
			base_offset = 1
		end
		local queued = false
		for _, effect in ipairs(effects) do
			for i = 1, effect:size() do
				local damage = effect:index(i)
				local attackedPawn = Board:GetPawn(damage.loc)
				--Nested ifs: first set are always required, second set is different conditions if the required ones are met
				if attackedPawn and not attackedPawn:IsDamaged() and attackedPawn:GetHealth() ~= 1 and damage.iDamage ~= DAMAGE_DEATH and attackedPawn:IsMech() and not attackedPawn:IsShield() and not attackedPawn:IsFrozen() then
					local offset = base_offset
					if armorDetection.IsArmor(attackedPawn) and not attackedPawn:IsAcid() then
						offset = offset - 1
					end
					if attackedPawn:IsAcid() and (damage.iDamage+offset)*2 >= attackedPawn:GetHealth() then
						damage.sImageMark = "icons/NAH_Protected_Fail.png"
					elseif damage.iDamage+offset >= attackedPawn:GetHealth() then

						if offset == 1 and attackedPawn:GetHealth() == 2 then --Boost and two health equals chaos
							damage.sScript = string.format([[
								local pawn = Board:GetPawn(%s);
								local oldMax = pawn:GetMaxHealth()
								pawn:SetMaxHealth(100);
								pawn:SetHealth(100);
								modApi:runLater(function()
									pawn:SetMaxHealth(oldMax);
									pawn:SetHealth(1);
								end)
							]],damage.loc:GetString())

							damage.iDamage = 2
							damage.sImageMark = "icons/NAH_Boost_Protected.png"
							--ADD THE 1 HEAL, IT GOES FIRST
							LOG(effect:size())
							local oldEffect = effect
							local oldEffectCopy = DamageList()
							--Make a copy
							for i = 1, oldEffect:size() do
								local oldDamage = oldEffect:index(i);
								oldEffectCopy:push_back(oldDamage)
							end
							LOG(queued)
							if queued then
								skillEffect.q_effect = DamageList()
							else
								skillEffect.effect = DamageList()
							end

							LOG(effect:size())
							for j = 1, oldEffectCopy:size() do
								local oldDamage = oldEffect:index(j)
								if j == i then
									local heal = SpaceDamage(oldDamage.loc,-1)
									effect:push_back(heal)
								end
								effect:push_back(oldDamage)
							end
							LOG(effect:size())
							LOG()
							break

						else
							damage.iDamage = attackedPawn:GetHealth()-1+offset
							damage.sImageMark = "icons/NAH_Protected.png"
						end
					end
				end
			end
			local queued = true
		end
	end
end

local function EVENT_OnModsLoaded()
  NAH_TND_ModApiExt:addSkillBuildHook(HOOK_SkillBuild)
	--modApi:addMissionStartHook(setVariables)
end

modApi.events.onModsLoaded:subscribe(EVENT_OnModsLoaded)
