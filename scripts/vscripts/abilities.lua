local damagePerUnit = 15
local hpPerUnit = 15
function addonName_titan_damage(keys)
	print("ede")
	local caster = keys.caster
	enemyUnits = FindUnitsInRadius(caster:GetTeamNumber(),
							Vector(0, 0, 0),
							nil,
							FIND_UNITS_EVERYWHERE,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_ALL,
							DOTA_UNIT_TARGET_FLAG_NONE,
							FIND_ANY_ORDER,
							false)
	--damagePerUnit = GetSpecialValueFor("damagePerUnit")
	caster:SetHealth(caster:GetMaxHealth()+table.getn(enemyUnits)*hpPerUnit)
	caster:SetMaxHealth(caster:GetMaxHealth()+table.getn(enemyUnits)*hpPerUnit)
	caster:SetBaseDamageMax(caster:GetBaseDamageMax()+table.getn(enemyUnits)*damagePerUnit)
	caster:SetBaseDamageMin(caster:GetBaseDamageMin()+table.getn(enemyUnits)*damagePerUnit)
	--npc:AddNewModifier(npc, nil, "modifier_stunned", {duration = 1000})
	print(table.getn(enemyUnits))
end
