function addonName_visage_create_wall(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()
	unitType = "npc_addonName_visage_wall"
	local unit = CreateUnitByName(unitType, pos, true, nil,nil, caster:GetTeamNumber())
	unit:SetForwardVector(Vector(0,1,0))
	unit:SetSize(Vector(0.5,0.5,0.5), Vector (3,3,3))
end
function addonName_titan_damage(keys)
	local damagePerUnit = 15
	local hpPerUnit = 15
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
end

function addonName_monkey_king_bonus_damage(keys)
	local damagePerAttack = 5
	caster = keys.caster
	caster:SetBaseDamageMax(caster:GetBaseDamageMax()+damagePerAttack)
	caster:SetBaseDamageMin(caster:GetBaseDamageMin()+damagePerAttack)
	local jinguStack = caster:FindModifierByName("addonName_monkey_king_bonus_damage_modifier")
	jinguStack:SetStackCount(jinguStack:GetStackCount() + 1)
	local JinguName = "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf" 
	local TenJingu =  "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead_model.vpcf"
	if not caster.OverHeadJingu then 
		caster.OverHeadJingu = ParticleManager:CreateParticle( JinguName, PATTACH_OVERHEAD_FOLLOW, caster)
	end
	ParticleManager:SetParticleControl(caster.OverHeadJingu, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.OverHeadJingu, 1, Vector(0,jinguStack:GetStackCount(),0))
	
end