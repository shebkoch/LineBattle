function addonName_enigma_damage_count(params)
	local unit = params.unit
	local ability = params.ability
	local knockback_ability = unit:GetAbilityByIndex(0) --аккуратнее
	if(unit.recieved_damage == nil) then --TODO refactor
		unit.recieved_damage = 0
	end
	unit.recieved_damage = unit.recieved_damage + params.Damage
	print(unit.recieved_damage)
	if(unit.recieved_damage >= ability:GetSpecialValueFor("damage_to_knockback")) then
		unit.recieved_damage = unit.recieved_damage - ability:GetSpecialValueFor("damage_to_knockback")
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
			AbilityIndex = knockback_ability:entindex(),
		}) 
	end
end

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
	local speedPerUnit = 7
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
	caster:SetBaseMoveSpeed(caster:GetBaseMoveSpeed() + table.getn(enemyUnits)*speedPerUnit)
	--npc:AddNewModifier(npc, nil, "modifier_stunned", {duration = 1000})
end

function addonName_monkey_king_bonus_damage(keys)
	local damagePerAttack = 5
	caster = keys.caster
	
	local jinguStack = caster:FindModifierByName("addonName_monkey_king_bonus_damage_modifier")
	if(jinguStack:GetStackCount() < 10) then 
		caster:SetBaseDamageMax(caster:GetBaseDamageMax()+damagePerAttack)
		caster:SetBaseDamageMin(caster:GetBaseDamageMin()+damagePerAttack)
		jinguStack:SetStackCount(jinguStack:GetStackCount() + 1)
	end
	local JinguName = "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf" 
	local TenJingu =  "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
	if not caster.OverHeadJingu then 
		caster.OverHeadJingu = ParticleManager:CreateParticle( JinguName, PATTACH_ABSORIGIN, caster)
	end
	ParticleManager:SetParticleControl(caster.OverHeadJingu, 0, caster:GetAbsOrigin()+Vector(0,0,260))
	ParticleManager:SetParticleControl(caster.OverHeadJingu, 1, Vector(0,jinguStack:GetStackCount(),0))
	if(jinguStack:GetStackCount() >= 10) then
		if caster.OverHeadJingu then 
			ParticleManager:DestroyParticle(caster.OverHeadJingu,true)
			keys.ability:ApplyDataDrivenModifier( caster, caster, "monkey_king_lifesteal",{})
			local tenParticle = ParticleManager:CreateParticle(TenJingu, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(tenParticle, 0, caster:GetAbsOrigin()+Vector(0,0,250))
		end
	end
end