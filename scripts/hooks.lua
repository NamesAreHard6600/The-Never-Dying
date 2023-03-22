local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath

local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

local function HOOK_SkillBuild(mission, attackingPawn, weaponId, p1, p2, skillEffect)
  if IsPassiveSkill("NAH_Ultra_Plated_Armor") then
    local effects = {skillEffect.effect,skillEffect.q_effect}
    for _, effect in ipairs(effects) do
			for i = 1, effect:size() do
				local damage = effect:index(i)
				local boost = false
        if attackingPawn and attackingPawn:IsBoosted() then
					damage.iDamage = damage.iDamage + 1
					local boost = true
        end
				local attackedPawn = Board:GetPawn(damage.loc)
        if attackedPawn and attackedPawn:IsMech() and not attackedPawn:IsDamaged() and Board:IsDeadly(damage,attackedPawn) then
          damage.sScript = string.format([[
            local pawn = Board:GetPawn(%s);
						Board:Ping(pawn:GetSpace(),GL_Color(0,255,0))
            local oldMax = pawn:GetMaxHealth()
            pawn:SetMaxHealth(100);
            pawn:SetHealth(100);
            modApi:runLater(function()
              pawn:SetMaxHealth(oldMax);
              pawn:SetHealth(1);
            end)
          ]],damage.loc:GetString())
          damage.sImageMark = "icons/NAH_Protected.png"
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
