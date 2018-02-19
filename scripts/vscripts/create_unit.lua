require("unitsTable")
function UnitCreate( event )
	unitId = event.ability:GetSpecialValueFor("addonName_unitID")
	local caster = event.caster
	local pos = caster:GetAbsOrigin()
	local unit = CreateUnitByName(addonName_unitIDs_table[unitId], pos, true, nil,nil, caster:GetTeamNumber())
	--local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--unit:MoveToNPC( units[1] )
	
end