function Spawn( entityKeyValues )
	isFirst = true;
	thisEntity:SetContextThink( "unitCtrl", unitCtrl, 1 )
	
end
function unitCtrl() 
	local attackRadius = thisEntity:GetAttackRange()
	local enemyHero = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	--print(thisEntity:GetAttackRange())
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then 
				if RandomInt(1,10) == 1 then
					return SpellCast(enemy)
				end
				return Attack(enemy)
			end
		end
	end
	for _,enemy in pairs( enemyHero ) do
		return Approach(enemy)
	end
end
function Approach(unit)
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
	print("attack")
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
function SpellCast(unit)
	print("skill")
	ability = thisEntity:FindAbilityByName("addonName_arc_lightning")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = unit:entindex(),
		AbilityIndex = ability:entindex(),
	})
	return 0.1
end