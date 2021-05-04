function Spawn( entityKeyValues )
	isFirst = true;
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 1 )
	
end
function unitCtrl() 
	if isFirst then
		isFirst = false
		print("spell start")
		return SpellCast()
	end
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	--print(thisEntity:GetAttackRange())
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then 
				return Attack(enemy)
			end
		end
	end
	for _,enemy in pairs( enemyHero ) do
		return Approach(enemy)
	end
end
function Approach(unit)
	print("Approach")
	print(unit)
	print(unit == nil)
	print(thisEntity)
	thisEntity.bMoving = true
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end
function Attack(unit)
	thisEntity.bMoving = false
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = unit:entindex()
		--Position = unit:GetOrigin(),
		--Queue = false,
	})
	return 0.5
end
function SpellCast()
	ability = thisEntity:FindAbilityByName("addonName_voodoo_restoration")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,	
		AbilityIndex = ability:entindex(),
	})
	return 0.1
end