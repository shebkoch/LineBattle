addonName_unitIDs_table = {
	[1] = "npc_addonName_hero_witch_doctor",
	[2] = "npc_dota_creature_zeus_test",
	[3] = "npc_addonName_hero_meepo",
	[4] = "npc_addonName_hero_techies"
}
function UnitCreate( event )
	unitId = event.ability:GetSpecialValueFor("addonName_unitID")
	local caster = event.caster
	local unit = CreateUnitByName(addonName_unitIDs_table[unitId], caster:GetAbsOrigin(), true, nil,nil, caster:GetTeamNumber())
	--local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--unit:MoveToNPC( units[1] )
	
end