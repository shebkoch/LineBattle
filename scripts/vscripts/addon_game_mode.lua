-- Generated from template
require('timers')
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
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
	GameRules:SetHeroSelectionTime(0)
	--GameRules:SetHeroStrategyTime(0)
	--GameRules:SetHeroShowcaseTime(0)
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	
	CustomGameEventManager:RegisterListener("event_test", Dynamic_Wrap(CAddonTemplateGameMode, 'OnTest'))
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end
function CAddonTemplateGameMode:OnTest( keys )
	for k,v in pairs(keys) do
		print(k,v)
	end
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