-- Generated from template
require('timers')
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	PrecacheEveryThingFromKV(context)
	PrecacheResource( "model", "models/heroes/techies/techies.vmdl", context )
	PrecacheModel("models/heroes/techies/techies.vmdl", context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	local GM = GameRules:GetGameModeEntity()
	GM:SetCustomGameForceHero("npc_dota_hero_axe")
	GM:SetFogOfWarDisabled(true)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,1)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,1)
	GameRules:SetHeroSelectionTime(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	--GameRules:SetHeroStrategyTime(0)
	--GameRules:SetHeroShowcaseTime(0)
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
	
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	ListenToGameEvent('dota_player_killed', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerKilled'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonTemplateGameMode, 'OnNPCSpawned'), self)
	CustomGameEventManager:RegisterListener("add_ability", Dynamic_Wrap(CAddonTemplateGameMode, 'AddAbility'))
	CustomGameEventManager:RegisterListener("Ready", Dynamic_Wrap(CAddonTemplateGameMode, 'StartGame'))
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end
local playersReady = 0
function CAddonTemplateGameMode:StartGame(keys)
	--SendToConsole("r_farz 5000")
	playersReady= playersReady + 1
	if(playersReady == PlayerResource:GetPlayerCount()) then --TODO: spectacor check
		local heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for k,v in pairs(heroes) do
			v:Purge(true,true,false,true,true)
			-- local ability_count = v:GetAbilityCount()
			-- for i = 0, ability_count do
				-- local ability = v:GetAbilityByIndex(i)
				-- if ability then
					-- ability:StartCooldown(ability:GetCooldown(1))
				-- end
			-- end
		end
	end
end

function CAddonTemplateGameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
	
	if(npc:IsHero()) then
		npc:AddNewModifier(npc, nil, "modifier_stunned", {duration = 1000})
		local ability_count = npc:GetAbilityCount()
		for i = 0, ability_count do
			local ability = npc:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(1)
			end
		end
		npc:RemoveAbility("axe_culling_blade")
		npc:RemoveAbility("axe_berserkers_call")
		npc:RemoveAbility("axe_battle_hunger")
		npc:RemoveAbility("axe_counter_helix")
	end
	
end
function CAddonTemplateGameMode:OnPlayerKilled(keys)
	GameRules:MakeTeamLose(PlayerResource:GetTeam(keys["PlayerID"]))
end
function CAddonTemplateGameMode:AddAbility( keys )
	print("23232")
	print(keys["playerID"])
	print(keys["AbilityId"])
	hero = PlayerResource:GetPlayer(keys["playerID"]):GetAssignedHero()
	hero:AddAbility(keys["AbilityId"])
	curAbility = hero:FindAbilityByName(keys["AbilityId"])
	curAbility:SetLevel(1)
end
-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function PrecacheEveryThingFromKV( context )
    local kv_files = {  	"scripts/npc/npc_units_custom.txt",
                            "scripts/npc/npc_abilities_custom.txt",
                            "scripts/npc/npc_heroes_custom.txt",
                            "scripts/npc/npc_abilities_override.txt",
							"scripts/npc/npc_units_abilities.txt",
                            "npc_items_custom.txt",
							"npc_units_abilities"
                          }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
end

function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle",  value, context)
                print("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then  
                PrecacheResource( "model",  value, context)
                print("PRECACHE MODEL RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                print("PRECACHE SOUND RESOURCE", value)
            end
        end
    end
end