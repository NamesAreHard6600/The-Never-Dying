local mod = modApi:getCurrentMod()
local modid = "NamesAreHard - The Never Dying"
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- Images
local imgs = {

}

local achname = "NAH_TND_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. achname..img ..".png")
	--modApi:appendAsset("img/achievements/".. achname..img .."_gray.png", path .."img/achievements/".. achname..img .."_gray.png")
end

--[[ Not needed atm
function NAH_TND_Chievo(id)
	-- exit if not our squad
	if GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] ~= "The Never Dying" then return end
	-- exit if current one is unlocked
	if modApi.achievements:isComplete(modid,id) then return end

	modApi.achievements:trigger(modid,id)
end]]

-- Achievements
local achievements = {
	NAH_PreventDeath = modApi.achievements:add{
		id = "NAH_TND_PreventDeath",
		name = "Cheating Death",
		tip = "Prevent the death of a Mech 7 times in a single mission.\nPrevented $ Deaths",
		img = "img/achievements/NAH_TND_PreventDeath.png",
		squad = "NAH_TheNeverDying",
		-- 6?
		objective = 7, -- Putting the objective here is a bit more complicated, but allows to show the number in the text
	},

}

-- Helper Functions
local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

local function isMission()
	local mission = GetCurrentMission()

	return true
		and isGame()
		and mission ~= nil
		and mission ~= Mission_Test
end

local function isMissionBoard()
	return true
		and isMission()
		and Board ~= nil
		and Board:IsTipImage() == false
end

local function AchIsValid(achid)
	return true
	 and not modApi.achievements:isComplete(modid,achid)
	 and GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] == "The Never Dying"
	 and isMissionBoard()
end

-- Reset Functions
local function ResetPreventDeathVars(mission)
	achievements.NAH_PreventDeath:addProgress(-achievements.NAH_PreventDeath:getProgress())
end

local function HOOK_MissionStart(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		ResetPreventDeathVars()
	end
end

local function HOOK_NextPhase(_, nextMission)
	Hook_MissionStart(nextMission)
end

local function HOOK_MissionEnd(mission)
	HOOK_MissionStart(mission)
end

local function HOOK_TurnStart(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		mission.NAH_TND_PreventDeathReset = 0
	end
end

local function HOOK_ResetTurn(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		achievements.NAH_PreventDeath:addProgress(-mission.NAH_TND_PreventDeathReset)
		mission.NAH_TND_PreventDeathReset = 0
	end
end



local function EVENT_onModsLoaded()
	modApi:addMissionStartHook(HOOK_MissionStart)
	modApi:addMissionNextPhaseCreatedHook(HOOK_NextPhase)
	modApi:addMissionEndHook(HOOK_MissionEnd)
	modApi:addNextTurnHook(HOOK_TurnStart)
	modapiext:addResetTurnHook(HOOK_ResetTurn)

end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

--Achievements:
-- Ultra Plated Armor:
-- Prevent X Damage in one *mission*/island/run
-- Prevent Death X Times in one *mission*/island/run

-- Huge arty
-- One shot X Vek in one *mission*/island/run

-- Support
-- Min-Maxing: Heal three allies and damage an enemy with one shot of the support weapon

-- Scream
-- Successfully taunt X enemies with one shot of the Piercing Screech (requires some code manipulation)

-- Misc.
-- Never Punished: Complete 4 Islands without a Mech being destroyed at the end of a battle
