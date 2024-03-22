local mod = modApi:getCurrentMod()
local modid = "NamesAreHard - The Never Dying"
local squadid = "NAH_TheNeverDying"
local path = mod_loader.mods[modApi.currentMod].resourcePath

--[[ Images
local imgs = {
	"PreventDeath",
	"AfterHim",
	"Immortal",
}

local achname = "NAH_TND_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. achname..img ..".png")
	--modApi:appendAsset("img/achievements/".. achname..img .."_gray.png", path .."img/achievements/".. achname..img .."_gray.png")
end--]]

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
		tip = "Prevent the death of a Mech 7 times in a single mission.\nPrevented $ Deaths", -- 6?
		image = path.."img/achievements/NAH_TND_PreventDeath.png",
		squad = squadid,
		objective = 7, -- Putting the objective here is a bit more complicated, but allows to show the number in the text
	},
	NAH_AfterHim = modApi.achievements:add{
		id = "NAH_TND_AfterHim",
		name = "After Him!",
		tip = "Successfully taunt 3 or more enemies with Piercing Screech and live.", -- 4?
		image = path.."img/achievements/NAH_TND_AfterHim.png",
		squad = squadid,
		objective = 1, -- I could technically provide more feedback on this one but it's a lot of work
	},
	NAH_Immortal = modApi.achievements:add{
		id = "NAH_TND_Immortal",
		name = "Immortal: Part 2",
		tip = "Finish 4 Corporate Islands without a Mech being destroyed at the end of a battle.\nValid: $valid\nIslands Finished: $islands",
		image = path.."img/achievements/NAH_TND_Immortal.png",
		squad = squadid,
		objective = {
			islands = 4,
			valid = true,
		},
	}
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
	 and GAME.additionalSquadData.squad == squadid
	 and isMissionBoard()
end

-- Reset Functions
local function ResetPreventDeathVars(mission)
	achievements.NAH_PreventDeath:addProgress(-achievements.NAH_PreventDeath:getProgress())
end

local function CheckAfterHim(mission, _)
	if AchIsValid("NAH_TND_AfterHim") then
		if mission.NAH_TND_AfterHim_Pawn ~= nil then
			local pawn = Board:GetPawn(mission.NAH_TND_AfterHim_Pawn)
			if not pawn:IsDead() then
				achievements.NAH_AfterHim:trigger()
			end
			mission.NAH_TND_AfterHim_Pawn = nil
		end
	end
end

local function HOOK_MissionStart(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		ResetPreventDeathVars()
	end
end

local function HOOK_MissionEnd(mission)
	HOOK_MissionStart(mission)

	if not achievements.NAH_Immortal:isComplete() then
		for i=0, 2 do
			local pawn = Board:GetPawn(i)
			if not pawn or pawn:IsDead() then
				achievements.NAH_Immortal:setProgress({valid=false})
			end
		end
		local progress = achievements.NAH_Immortal:getProgress()
		if mission.BossMission and progress.valid and progress.islands == 3 then --Third island boss and valid
			achievements.NAH_Immortal:trigger()
		end
	end

	-- Vek don't move and the players turn doesn't start on the last turn
	-- So we also check this achievement at mission end
	CheckAfterHim(mission)
end

local function HOOK_TurnStart(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		mission.NAH_TND_PreventDeathReset = 0
	end
	-- Just in case no Vek move, we also check for this achievement at player turn start
	-- But Vek Move Start Should trigger the achievement most of the time
	if Game:GetTeamTurn() == TEAM_PLAYER then
		CheckAfterHim(mission)
	end
end

local function HOOK_ResetTurn(mission)
	if AchIsValid("NAH_TND_PreventDeath") then
		achievements.NAH_PreventDeath:addProgress(-mission.NAH_TND_PreventDeathReset)
		mission.NAH_TND_PreventDeathReset = 0
	end
end

local function EVENT_onIslandLeft(island)
	if not modApi.achievements:isComplete(modid,"NAH_TND_Immortal") then
		local progress = achievements.NAH_Immortal:getProgress()
		if progress.valid then
			achievements.NAH_Immortal:addProgress({islands=1})
		end
	end
end

local function HOOK_GameStart()
	if not modApi.achievements:isComplete(modid,"NAH_TND_Immortal") then
		if GAME.additionalSquadData.squad == squadid then
			achievements.NAH_Immortal:setProgress({islands=0, valid=true})
		else
			achievements.NAH_Immortal:setProgress({islands=0, valid=false})
		end
	end
end


local function EVENT_onModsLoaded()
	modApi:addMissionStartHook(HOOK_MissionStart)
	modApi:addMissionEndHook(HOOK_MissionEnd)
	modApi:addNextTurnHook(HOOK_TurnStart)
	modApi:addPostStartGameHook(HOOK_GameStart)
	modapiext:addResetTurnHook(HOOK_ResetTurn)

	modapiext:addVekMoveStartHook(CheckAfterHim)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

modApi.events.onIslandLeft:subscribe(EVENT_onIslandLeft)

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
