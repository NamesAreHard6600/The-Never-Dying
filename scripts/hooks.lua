local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath

local function IsPassive()
  return IsPassiveSkill("NAH_Ultra_Plated_Armor")
end

local function HOOK_SkillBuild(mission, attackingPawn, weaponId, p1, p2, skillEffect)
  if IsPassive() and mission and not Board:IsTipImage() then
    local effects = {skillEffect.effect,skillEffect.q_effect}
    for _, effect in ipairs(effects) do
			for i = 1, effect:size() do
				local damage = effect:index(i)
				local boost = false
        if attackingPawn and attackingPawn:IsBoosted() and damage.iDamage ~= DAMAGE_DEATH then
					damage.iDamage = damage.iDamage + 1
					boost = true
        end
				local attackedPawn = Board:GetPawn(damage.loc)
        if attackedPawn and --A pawn is being attacked
        attackedPawn:IsMech() and --That pawn is a mech
        not attackedPawn:IsDamaged() and --That pawn is at full health
        attackedPawn:GetMaxHealth() ~= 1 and --Full health isn't 1 health
        Board:IsDeadly(damage,attackedPawn) and --The damage is going to kill them
        not attackedPawn:IsShield() and --They don't have shield (networked shiedling gets passed IsDeadly)
        damage.iDamage ~= DAMAGE_DEATH then --It's not death damage
          damage.sScript = string.format([[
            local pawn = Board:GetPawn(%s);
						local mission = GetCurrentMission()
						Board:Ping(pawn:GetSpace(),GL_Color(0,255,0))
            local oldMax = pawn:GetMaxHealth()
            pawn:SetMaxHealth(100);
            pawn:SetHealth(100);
            modApi:runLater(function()
              pawn:SetMaxHealth(oldMax);
              pawn:SetHealth(1);
              if IsPassiveSkill("NAH_Ultra_Plated_Armor_A") or IsPassiveSkill("NAH_Ultra_Plated_Armor_AB") then
                Board:SetShield(pawn:GetSpace(),true)
              end
            end)

            if not modApi.achievements:isComplete("NamesAreHard - The Never Dying", "NAH_TND_PreventDeath") then
              mission.NAH_TND_PreventDeathReset = mission.NAH_TND_PreventDeathReset + 1
              modApi.achievements:addProgress("NamesAreHard - The Never Dying", "NAH_TND_PreventDeath", 1)
            end
          ]],damage.loc:GetString())
          damage.sImageMark = "icons/NAH_Protected.png"
          damage.sAnimation = "NAH_Protected_Anim"
        end
        if boost then
          damage.iDamage = damage.iDamage - 1
        end
      end
    end
  end
end

local function EVENT_OnModsLoaded()
  NAH_TND_ModApiExt:addSkillBuildHook(HOOK_SkillBuild)
	--modApi:addMissionStartHook(setVariables)
end

modApi.events.onModsLoaded:subscribe(EVENT_OnModsLoaded)
